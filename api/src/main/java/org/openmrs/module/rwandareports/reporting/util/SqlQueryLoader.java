package org.openmrs.module.rwandareports.reporting.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Utility class for loading SQL queries from external resource files
 * Provides caching and parameter replacement with SQL injection prevention
 * 
 * @author smallGod
 */
public class SqlQueryLoader {

	protected final static Log log = LogFactory.getLog(SqlQueryLoader.class);

	/**
	 * Cache for loaded SQL queries to avoid repeated file I/O
	 * Thread-safe for concurrent access
	 */
	private static final Map<String, String> queryCache = new ConcurrentHashMap<>();

	/**
	 * Loads SQL query from classpath resource with caching
	 * Thread-safe with proper resource management
	 *
	 * @param resourcePath Path to SQL file relative to classpath (e.g.,
	 *                     "sql/lab_result_report.sql")
	 * @return SQL query string
	 * @throws IllegalArgumentException if resource not found
	 * @throws RuntimeException if resource cannot be read
	 */
	public static String loadQuery(String resourcePath) {
		if (resourcePath == null || resourcePath.trim().isEmpty()) {
			throw new IllegalArgumentException("Resource path cannot be null or empty");
		}

		// Check cache first (thread-safe read)
		String cached = queryCache.get(resourcePath);
		if (cached != null) {
			return cached;
		}

		// Load from resource with proper resource management
		log.debug("Loading SQL query from: " + resourcePath);

		try (InputStream is = SqlQueryLoader.class.getClassLoader().getResourceAsStream(resourcePath)) {
			if (is == null) {
				throw new IllegalArgumentException("SQL file not found in classpath: " + resourcePath);
			}

			try (Scanner scanner = new Scanner(is, "UTF-8")) {
				scanner.useDelimiter("\\A");
				String sql = scanner.hasNext() ? scanner.next() : "";

				log.debug("Loaded SQL query (" + sql.length() + " characters)");

				// Cache for future use (thread-safe write)
				queryCache.putIfAbsent(resourcePath, sql);

				return sql;
			}
		} catch (IOException e) {
			throw new RuntimeException("Failed to read SQL file: " + resourcePath, e);
		}
	}

	/**
	 * Loads SQL query and replaces placeholders with validated parameters
	 * Validates parameter types to prevent SQL injection
	 *
	 * @param resourcePath Path to SQL file relative to classpath
	 * @param params       Map of placeholder names to values (placeholders are
	 *                     surrounded by curly braces in SQL)
	 * @return SQL query with placeholders replaced
	 * @throws IllegalArgumentException if resource not found or parameter type is invalid
	 * @throws RuntimeException if resource cannot be read
	 */
	public static String loadQueryWithParams(String resourcePath, Map<String, Object> params) {

		if (params == null || params.isEmpty()) {
			log.warn("No parameters provided for SQL query: " + resourcePath);
			return loadQuery(resourcePath);
		}

		String sql = loadQuery(resourcePath);

		// Replace each placeholder with validated parameter value
		for (Map.Entry<String, Object> entry : params.entrySet()) {
			String placeholder = "{" + entry.getKey() + "}";
			Object value = entry.getValue();

			// Validate parameter type to prevent SQL injection
			// Only allow numeric types for dynamic SQL values
			if (value instanceof Integer || value instanceof Long) {
				String replacement = String.valueOf(value);
				sql = sql.replace(placeholder, replacement);
				log.debug("Replaced placeholder " + placeholder + " with value: " + replacement);
			} else {
				throw new IllegalArgumentException(
						"Invalid parameter type for '" + entry.getKey() + "': " +
								"expected Integer or Long, but got " +
								(value == null ? "null" : value.getClass().getSimpleName()) +
								". Only numeric types are allowed to prevent SQL injection.");
			}
		}

		// Log warning if any placeholders remain unreplaced
		if (sql.contains("{") && sql.contains("}")) {
			log.warn("SQL query contains unreplaced placeholders. This may indicate missing parameters.");
		}

		return sql;
	}

	/**
	 * Clears the query cache
	 * Useful for testing or when SQL files are modified at runtime
	 */
	public static void clearCache() {
		log.info("Clearing SQL query cache (" + queryCache.size() + " entries)");
		queryCache.clear();
	}

	/**
	 * Returns the number of cached queries
	 * Useful for monitoring and debugging
	 */
	public static int getCacheSize() {
		return queryCache.size();
	}
}
