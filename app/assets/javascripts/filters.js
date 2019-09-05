var addToList = function(filterId, values) {
    if (!Array.isArray(values)) {
        $("#"+filterId).prop("checked", values.value === 'true');
    } else {
        values.map(function(currValue) {
            $('#' + filterId).parents(".row").next('.row').find('.badges').append(
              '<span class="badge badge-secondary filter-tag">' +
              currValue.label +
              '<i name="' + currValue.label + '" id="remove-' + filterId + '-' + currValue.value + '" class="fas fa-window-close remove-filter"></i>' +
              '</span>'
            );
            $('#remove-'+filterId+'-'+currValue.value).on('click', {id: filterId, value: currValue.value, label: currValue.label}, removeFilter)
        })
    }

}

var removeFilter = function(event) {
    $.post('/remove_filter', { filter_array: [ {
        filter_name: event.data.id,
        filter_value: event.data.value,
        filter_label: event.data.label
    } ] }, function() {
        const card = $(event.target).closest('.badge');
        card.fadeOut();

        window.location.reload(true);
    });

}

var addFilter = function(id, value, label) {
    $.post('/add_filter', {
        filter_name: id,
        filter_value: value,
        filter_label: label
    }, function () {
        window.location.reload(true);
    });
}

var prepareFilters = function() {

    $('.filter-element').change(function() {
        var id = $(this).attr('id');
        if ($(this).is(':checkbox')) {
            $(this).is(":checked") ? addFilter(id, true) : removeFilter({data: {id: id}});
        } else {
            var val = $(this).children("option:selected").val();
            var label = $(this).children("option:selected").text();
            addFilter(id, val, label)
        }
    });

    $('.clear-all').on('click', function() {
        filterList = [];
        $(this).parents(".accordion-body").find('.remove-filter').not('input').each(function() {
            // collect all of the filters to remove
            filterId = $(this).attr('id').split('-');
            filterLabel = $(this).attr('name');
            currFilter = { filter_name: filterId[1], filter_value: filterId[2], filter_label: filterLabel }
            filterList.push(currFilter);
        });

        $(this).parents(".accordion-body").find('input.filter-element').each(function() {
          filterId = $(this).attr('id');
          filterList.push({ filter_name: filterId });
        });

        if (filterList.length > 0) {
            $.post('/remove_filter', { filter_array: filterList }, function() {
              const card = $(this).parents(".row").next('.row');
              card.fadeOut();
              
              window.location.reload(true);
            });
        }
    });

    // Get all filters and add to List
    $.get('/get_filters', function (data) {
        Object.keys(data).map(function(key) {
            addToList(key, data[key]);
        })

    });
}

$(document).on("turbolinks:load", prepareFilters);