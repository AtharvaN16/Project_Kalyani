---
name: save-context
description: Saves a piece of context to a specified file within the `context/` directory and updates the glossary. Use this when the user provides a new piece of information, a rule, or a concept that should be remembered for the project.
---

# Save Context Skill

This skill helps in saving new pieces of information into the project's context files, located in the `context/` directory, and maintaining the project glossary.

## Workflow

1.  **Identify New Context**: When the user provides a new piece of information, a rule, or a concept that should be part of the project's knowledge base, identify this as new context to be saved.
2.  **Determine Target File**: Based on the project's context structure, determine the most appropriate file to save the new information. The file path should be within the `context/` directory (e.g., `context/systems/loyalty/context.md`). If a suitable file doesn't exist, you can create a new one.
3.  **Use the Script to Save Context**: Execute the `save-context.js` script to append the new context to the target file.
4.  **Update the Glossary**: After saving the new context, you must update the project's glossary (`glossary.md`).

## Glossary Maintenance

After successfully saving a new piece of context, follow these steps to maintain the glossary:

1.  **Analyze the new context** and identify any new, significant terms that are not common knowledge and are specific to this project.
2.  **Check `glossary.md`** to see if these terms already have entries.
3.  For each new term that is not in the glossary:
    *   Formulate a concise definition based on the context you just saved.
    *   Append the new term and its definition to `glossary.md`, following the existing alphabetical and formatting conventions.

## `save-context.js` Script

This script appends the given content to the specified file. It automatically creates directories if they don't exist and warns if the file exceeds 200 lines.

### Usage

```bash
node <path-to-skill>/scripts/save-context.js <file-path> "<content>"
```

### Arguments

-   `<file-path>`: The absolute or relative path to the markdown file where the context should be saved. This should point to a file inside the `context/` directory.
-   `<content>`: The new piece of context to save. **This must be enclosed in double quotes.**

### Example

If the user says: *"For fishing villages, there should be a new building called 'Net Maker' that costs 25 wood and increases fish production by 10%."*

1.  **Save the context**:
    ```bash
    node ./save-context/scripts/save-context.js context/settlements/specializations/context.md "For fishing villages, there should be a new building called 'Net Maker' that costs 25 wood and increases fish production by 10%."
    ```
2.  **Update the glossary**:
    *   Identify "Net Maker" as a new term.
    *   Check `glossary.md` to confirm it's not there.
    *   Append a new entry to `glossary.md` under 'N':
        > -   **Net Maker**: A building unique to Fishing villages that increases fish production by 10%.
