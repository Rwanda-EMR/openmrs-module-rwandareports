#!/bin/bash

# ============================================================================
# Rwanda Reports Module - Build and Deploy Script
# ============================================================================
# Purpose: Automates building and deploying the rwandareports module
# Author: smallgod (with Claude Code assistance)
# Date: December 9, 2025
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
MODULE_NAME="rwandareports-3.0.0-SNAPSHOT.omod"
DEPLOY_DIR="/Users/smallgod/openmrs/rwanda-emr/modules"
SOURCE_DIR="/Users/smallgod/srv/applications/mets/openmrs-module-rwandareports"

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Rwanda Reports Module Deployment${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Step 1: Navigate to source directory
echo -e "${YELLOW}[1/6]${NC} Navigating to source directory..."
cd "$SOURCE_DIR" || exit 1
echo -e "${GREEN}✓${NC} Current directory: $(pwd)"
echo ""

# Step 2: Clean and build
echo -e "${YELLOW}[2/6]${NC} Building module (this may take 2-3 minutes)..."
mvn clean package -DskipTests
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Build successful!"
else
    echo -e "${RED}✗${NC} Build failed! Check errors above."
    exit 1
fi
echo ""

# Step 3: Verify build artifact
echo -e "${YELLOW}[3/6]${NC} Verifying build artifact..."
if [ -f "omod/target/$MODULE_NAME" ]; then
    FILE_SIZE=$(du -h "omod/target/$MODULE_NAME" | cut -f1)
    echo -e "${GREEN}✓${NC} Found: omod/target/$MODULE_NAME ($FILE_SIZE)"
else
    echo -e "${RED}✗${NC} Build artifact not found!"
    exit 1
fi
echo ""

# Step 4: Backup existing module
echo -e "${YELLOW}[4/6]${NC} Backing up existing module..."
if [ -f "$DEPLOY_DIR/$MODULE_NAME" ]; then
    BACKUP_NAME="${MODULE_NAME}.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$DEPLOY_DIR/$MODULE_NAME" "$DEPLOY_DIR/$BACKUP_NAME"
    echo -e "${GREEN}✓${NC} Backup created: $BACKUP_NAME"
else
    echo -e "${YELLOW}⚠${NC}  No existing module found (first deployment?)"
fi
echo ""

# Step 5: Deploy new module
echo -e "${YELLOW}[5/6]${NC} Deploying new module..."
cp "omod/target/$MODULE_NAME" "$DEPLOY_DIR/"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Module deployed to: $DEPLOY_DIR/"
else
    echo -e "${RED}✗${NC} Deployment failed!"
    exit 1
fi
echo ""

# Step 6: Verify deployment
echo -e "${YELLOW}[6/6]${NC} Verifying deployment..."
if [ -f "$DEPLOY_DIR/$MODULE_NAME" ]; then
    DEPLOYED_SIZE=$(du -h "$DEPLOY_DIR/$MODULE_NAME" | cut -f1)
    DEPLOYED_TIME=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$DEPLOY_DIR/$MODULE_NAME")
    echo -e "${GREEN}✓${NC} Deployed successfully!"
    echo -e "   Size: $DEPLOYED_SIZE"
    echo -e "   Time: $DEPLOYED_TIME"
else
    echo -e "${RED}✗${NC} Deployment verification failed!"
    exit 1
fi
echo ""

# Success summary
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}✓ DEPLOYMENT SUCCESSFUL!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}NEXT STEPS:${NC}"
echo "1. Restart OpenMRS server"
echo "2. Log into OpenMRS"
echo "3. Go to: Administration → Rwanda Reports"
echo "4. Find 'Lab - Results Report'"
echo "5. Click '(Re) register'"
echo "6. Test the report with new columns!"
echo ""
echo -e "${YELLOW}Expected new columns:${NC}"
echo "  - Column 13: Ordered By (provider who requested exam)"
echo "  - Column 14: Result Entered By (user who recorded result)"
echo ""

exit 0
