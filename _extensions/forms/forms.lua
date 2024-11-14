-- Forms.lua
-- Author: Jonathan Graves

-- Helper Functions

local function addHTMLDeps()
  -- add the HTML requirements for the library used
    quarto.doc.add_html_dependency({
    name = 'forms',
    stylesheets = {'forms.css'}
  })
end

local function isEmpty(s)
  return s == '' or s == nil
end

-- Main Form Function Shortcode

return {

["form"] = function(args, kwargs, meta)


  if quarto.doc.is_format("html:js") then
    -- this will only run for HTML documents
    addHTMLDeps()

    local submit_text = pandoc.utils.stringify(meta["form.submit"])
    local action = pandoc.utils.stringify(meta["form.action"])
    local formid = "form"
    if not isEmpty(meta["form.id"]) then
      form_id = pandoc.utils.stringify(meta["form.id"])
    end
    
    -- If the user passes a method, use it, otherwise use GET   
    if not isEmpty(meta["form.method"]) then
      method = pandoc.utils.stringify(meta["form.method"])
    else
      method = "GET"
    end

    -- These are the form items
    -- action (form.action) describes the handler function for the form submit
    local form_start = "<div id = \"" .. formid .. "-div\" class = \"form-wrapper\">\n <form id = \"" .. formid .. "\" action = \"" .. action .. "\" method = \"" .. method .. "\">\n"
    local form_end = "</form></div>\n"

    -- Fields for the Form --
    local fields = meta["form.fields"]

    for f = 1, #fields do
      
      local field = fields[f]

      local required = ""
      if not isEmpty(field.required) and pandoc.utils.stringify(field.required) == "true" then
        required = " required"
      end


      if isEmpty(field.type) and not isEmpty(field.text) then
      -- Handle non-fields (i.e. text)
        
        text = pandoc.utils.stringify(field.text)

        if text == "—" then
          form_start = form_start .. "<hr>" .. "\n"
        else
          form_start = form_start .. "<br><p>" .. text .. "</p>\n"
        end
      else 
      -- Handle regular form fields

        local name = pandoc.utils.stringify(field.name)
        local type = pandoc.utils.stringify(field.type)
        local id = pandoc.utils.stringify(field.id)
        local label = pandoc.utils.stringify(field.label)

        if type == "text" then
        -- Handle text fields

          form_start = form_start .. "<div class=\"form-group\">\n"
          form_start = form_start .. "<label for=\"" .. id .. "\" class = \"form-label mt-4\">" .. label .. "</label>\n"
          form_start = form_start .. "  <input type = \"text\" id = \"" .. id .. "\" name = \"" .. name .. "\" class = \"form-control\" " .. required .. " >\n"
          form_start = form_start .. "</div>\n"

        elseif type == "textarea" then
        -- Handle textarea fields
          local cols = "30"
          local rows = "10"

          if not isEmpty(field.width) then
              cols = pandoc.utils.stringify(field.width)
          end

          if not isEmpty(field.height) then
            rows = pandoc.utils.stringify(field.height)
          end
          
          form_start = form_start .. "<div class=\"form-group\">\n"
          form_start = form_start .. "<label for =\"" .. id .. "\">" .. label .. "</label class = \"form-label mt-4\">\n"
          form_start = form_start .. "<textarea name =\"" .. name .. "\" id = \"" .. id .. "\" rows = \"" .. rows .. "\" cols =\"" .. cols .."\" class = \"form-control\"></textarea>\n"
          form_start = form_start .. "</div>\n"
        
        elseif type == "email" then
        -- Handle email address inputs
          form_start = form_start .. "<div class=\"form-group\">\n"
          form_start = form_start .. "<label for=\"" .. id .. "\" class=\"form-label mt-4\">" .. label .. "</label>\n"
          form_start = form_start .. "<input type=\"email\" id=\"" .. id .. "\" name=\"" .. "\" class=\"form-control\" " .. required .. ">\n"
          form_start = form_start .. "</div>\n"

        elseif type == "file" then
        -- Handle file form inputs

        form_start = form_start .. "<div class=\"form-group\">\n"
        form_start = form_start .. "<label for=\"" .. id .. "\" class=\"form-label mt-4\">" .. label .. "</label>\n"
        form_start = form_start .. "<input type=\"file\" id = \"" .. id .. "\" name=\"" .. name .. "\" class=\"form-control\" " .. required .. " >\n"
        form_start = form_start .. "</div>\n"
        
        elseif type == "select" then
        -- Handle selector (drop-downs)
          
          local size = "3" 
          if not isEmpty(field.size) then
            size =  pandoc.utils.stringify(field.size)
          end


          local multiple = "" 
          if not isEmpty(field.multiple) then
            if pandoc.utils.stringify(field.multiple) == "true" then
              multiple = "multiple=\"\""
            end
          end

          form_start = form_start .. "<div class=\"form-group\">\n"
          form_start = form_start .. "<label for = \"" .. id .. "\" class=\"form-label mt-4\">" .. label .. "</label>\n"
          form_start = form_start .. "<select id= \"" .. id .. "\" size = \"" .. size .. "\" " .. multiple .. " " .. required .. " class=\"form-select\">\n"
          
          for v = 1,#field.values do
            local value = field.values[v]
            local label_t = pandoc.utils.stringify(value.text)
            local val = pandoc.utils.stringify(value.value)

            form_start = form_start .. "  <option value = \"" .. val .. "\">" .. label_t .. "</option>\n"
            
          end

          form_start = form_start .. "</select>\n</div>\n"
            
        else
        -- Handle radio and checkboxes

          local class = ""
          local labelclass = ""
          local checked = ""

          if type == "radio" then
            class = "form-check-input"
            labelclass = "form-check-label"
            checked = "checked=\"\""
          elseif type == "checkbox" then
            class = "form-check-input"
            labelclass = "form-check-label"
          end

          form_start = form_start .. "<div class=\"form-group\">\n"
          form_start = form_start .. "<fieldset class=\"form-group\">\n"
          form_start = form_start .. "<p class = \"form-label\">" .. label .. "</p>\n"
          for v = 1, #field.values do

            local value = field.values[v]
            -- multi-option fields need to have a label for each value
            local label_t = "&nbsp;" .. pandoc.utils.stringify(value.text)
            local val = pandoc.utils.stringify(value.value)

            form_start = form_start .. "<div class=\"form-check\">\n"
            form_start = form_start .. "  <input type = \"" .. type .. "\" id = \"" .. id .. v .. "\" name = \"" .. name .. "\" value =\"" .. val .. "\"" .. " class =\"" .. class .. "\" autocomplete=\"off\" " .. checked .. " " .. required .. " >\n"
            form_start = form_start .. "  <label for=\"" .. id .. v .. "\" class=\"" .. labelclass .. "\">" .. label_t .. "</label>\n"
            form_start = form_start .. "</div>\n"
          end

          form_start = form_start .. "</fieldset>\n</div>\n"


        end

      end
    end
    -- Close the form and submit
    form_start = form_start .. "<br>\n<div class=\"form-group\">\n"
    form_start = form_start .. "  <input type=\"submit\" value = \"" .. submit_text .. "\" class=\"btn btn-primary\">\n</div>\n"
    form_start = form_start .. form_end
    -- quarto.log.output(form_start)
    return pandoc.RawInline("html", form_start)


  else
    return pandoc.Null()
  end

end

}

