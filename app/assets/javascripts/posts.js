
$(document).ready(function(){
    $('#lang_selection > button').click(function(){
        var el = $(this);
        $('#post_lang_id').attr('value', el.attr('lang_id'));
    });

    $('#edit_preview_button').click(function(e){
        var lang_id = $('#post_lang_id').attr('value') ;
        var body =  $('#post_raw_body').attr('value');

        $('#preview_lang_id').attr('value', lang_id);
        $('#preview_body').attr('value', body);
        $('#preview_ts').attr('value', new Date().getTime());

        $('#preview_form').submit();
        e.preventDefault();

        return false;
    });
});
