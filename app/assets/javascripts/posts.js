
$(document).ready(function(){
    $('#lang_selection > button').click(function(){
        var el = $(this);
        $('#post_lang_id').attr('value', el.attr('lang_id'));
    });
});