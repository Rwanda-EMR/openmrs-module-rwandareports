# Controller Registration Issue - Root Cause Analysis

**Date**: December 10, 2025
**Issue**: All @RequestMapping controller endpoints return 404

---

## Problem Statement

Production server shows:
```
WARN - DispatcherServlet.noHandlerFound(1283) |2025-12-10T05:53:59,536|
No mapping for GET /openmrs/module/rwandareports/register_LabResultReport.form
```

**Affects**: ALL (Re)register links for ALL reports, not just lab reports

---

## Investigation Timeline

### Finding #1: Component-Scan in Wrong Context
- **moduleApplicationContext.xml**: HAS component-scan ✅
- **webModuleApplicationContext.xml**: NO component-scan ❌

**Action**: Added component-scan to webModuleApplicationContext.xml

### Finding #2: Component-Scan Present But Not Working
- Deployed module (Dec 10 05:40) HAS component-scan
- Tomcat restarted (05:41)
- Still failing (05:53)
- **No Spring bean registration logs** for controllers

### Finding #3: Missing MVC Configuration
- No `<mvc:annotation-driven/>` in any config
- Spring needs this to process @RequestMapping annotations

### Finding #4: OpenMRS Pattern Discovery
ALL OpenMRS modules use **old-style bean definitions**, NOT @RequestMapping:
- legacyui: Manual bean definitions
- xforms: Manual bean definitions
- referenceapplication: Manual bean definitions

---

## Root Cause

**The module uses @Controller/@RequestMapping annotations but OpenMRS doesn't support this pattern without additional configuration.**

Traditional OpenMRS modules use:
```xml
<bean id="myController" class="...MyController">
    <property name="commandName" value="..." />
</bean>
```

This module uses modern annotations:
```java
@Controller
public class RwandaSetupReportsFormController {
    @RequestMapping("/module/rwandareports/register_LabResultReport")
    public ModelAndView registerReport() { ... }
}
```

---

## Solutions

### Option 1: Add MVC Support (Modern Approach)

**Add to webModuleApplicationContext.xml:**

1. Add MVC namespace:
```xml
xmlns:mvc="http://www.springframework.org/schema/mvc"
```

2. Add to schemaLocation:
```xml
http://www.springframework.org/schema/mvc
http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd
```

3. Enable annotation-driven MVC:
```xml
<context:component-scan base-package="org.openmrs.module.rwandareports.web.controller" />
<mvc:annotation-driven />
```

**Pros:**
- Modern approach
- Less XML configuration
- More maintainable

**Cons:**
- Untested in OpenMRS 1.x
- May have compatibility issues

---

### Option 2: Convert to Bean Definitions (Traditional Approach)

**Add explicit beans for each controller method:**

```xml
<bean id="registerLabResultReportController"
      class="org.springframework.web.servlet.mvc.ParameterizableViewController">
    <property name="viewName" value="redirect:rwandareports.form" />
</bean>

<bean class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
    <property name="order" value="45" />
    <property name="mappings">
        <props>
            <prop key="/module/rwandareports/register_LabResultReport.form">
                registerLabResultReportController
            </prop>
            <!-- Repeat for ~80 other endpoints -->
        </props>
    </property>
</bean>
```

**Pros:**
- Proven OpenMRS pattern
- Will definitely work

**Cons:**
- ~80+ bean definitions needed
- High maintenance
- Lots of XML

---

### Option 3: Custom HandlerMapping (Hybrid Approach)

Create a custom handler mapping that delegates to the annotated controller:

```xml
<bean class="org.openmrs.module.rwandareports.web.AnnotationControllerMapping">
    <property name="order" value="45" />
    <property name="controller" ref="rwandaSetupReportsFormController" />
</bean>

<bean id="rwandaSetupReportsFormController"
      class="org.openmrs.module.rwandareports.web.controller.RwandaSetupReportsFormController" />
```

---

## Questions for User

1. **Does this work on your local OpenMRS?**
   - If YES: Check local module version and config
   - If NO: We need to implement one of the solutions

2. **When was this module last working in production?**
   - Check git history for when @RequestMapping was introduced
   - May have always been broken

3. **Preference for solution?**
   - Modern (mvc:annotation-driven)
   - Traditional (bean definitions)
   - Hybrid (custom mapping)

---

## Next Steps

**Immediate:**
1. Confirm whether local instance actually works
2. Check git history for @RequestMapping introduction
3. Choose solution approach

**Implementation:**
- Add MVC configuration and test
- OR convert to bean definitions
- OR implement custom handler mapping

---

## References

- OpenMRS Annotation-Driven Spring MVC: https://wiki.openmrs.org/display/docs/Annotation-driven+Spring+MVC (404)
- Spring MVC 3.0 Docs: https://docs.spring.io/spring-framework/docs/3.0.x/spring-framework-reference/html/mvc.html
- OpenMRS Module Examples: https://github.com/openmrs
