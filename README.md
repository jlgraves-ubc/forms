# Forms Extension For Quarto

This extension allows you to add an HTML form to your Quarto HTML pages, using the the `form` shortcode



## Installing

```bash
quarto add jlgraves-ubc/forms
```
This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

The forms extension has two parts:

1) A set of metadata, in the document header, which defines the form's part
2) A shortcode `{{< form >}}` which embeds it in the appropriate place in the document.

## Form Definition

You define a form using the metadata in the document header, as follows:

```yaml
---
form:
  action: "/action.js"
  submit: "Submit Now!"
  fields:
  - name: "A Text Field"
  - type: "text"
  - id: "textfield1" 
---
```

Fields which take multiple entry values take a `values` parameter, which looks like:

```yaml
  - name: Checkbox
    type: checkbox
    id: checkbox1
    label: "My Checkbox"
    values:
    - text: "High"
      value: "hi"
    - text: "Low"
      value: "lo"
    - text: "Mid"
      value: "mid"
```

You can see more detailed (and better-formatted) documentation in the example, below.

## To Do:

* Add `orientation` option (removes `<br>` tag to make thing horizontal or vertical)
* Add CSS classes from Bootswatch theming
* Add a JS example for form output

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

