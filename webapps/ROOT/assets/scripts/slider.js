/**
/* Code for handling the creation and updating of a range slider for
/* use in forms.
/*
/* This code depends on jQuery, jQuery UI, and URI.js.
**/

function update_slider_label(widget, label, values) {
    var prefix = widget.data("label-prefix") + " ",
        suffix = " " + widget.data("label-suffix");
    label.text(prefix + values[0] + " – " + values[1] + suffix);
}

function setup_slider(widget, label) {
    widget.slider({
        range: true,
        min: widget.data("range-min"),
        max: widget.data("range-max"),
        values: [widget.data("value-min"), widget.data("value-max")],
        step: widget.data("step"),

        create: function() {
            update_slider_label($(this), label, $(this).slider('values'));
        },

        slide: function(event, ui) {
            update_slider_label($(this), label, ui.values);
        },

        stop: function(event, ui) {
            var params = URI.parseQuery(
                URI.parse(document.location.href).query);
            var field_name = $(this).data("field-name");
            params[field_name + "_start"] = ui.values[0];
            params[field_name + "_end"] = ui.values[1];
            document.location.href = "?" + URI.buildQuery(params);
        }
    });
}

function prepare_form(form, slider, inputs) {
    var field_name = slider.data("field-name");
    var params = URI.parseQuery(URI.parse(document.location.href).query);
    if (params[field_name + "_start"]) {
        slider.data("value-min", params[field_name + "_start"]);
    }
    if (params[field_name + "_end"]) {
        slider.data("value-max", params[field_name + "_end"]);
    }
    console.log(params[field_name + "_start"]);
    form.on("submit", function(e) {
        e.preventDefault();
        for (i = 0; i < inputs.length; i++) {
            params[inputs[i]] = $("#" + inputs[i]).val();
        }
        document.location.href = "?" + URI.buildQuery(params);
    });
}
