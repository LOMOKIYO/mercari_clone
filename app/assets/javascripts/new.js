$(function(){
    let maxFileSize = 10
  $(document).on('change', 'input[type="file"]', function(e) {
    var file = e.target.files[0],
        reader = new FileReader(),
        $preview = $(".preview");
        t = this;

    if(file.type.indexOf("image") < 0){
      return false;
    }

    reader.onload = (function(file) {
      return function(e) {
        $preview.append($('<img>').attr({
                  src: e.target.result,
                  height: "124px",
                  width: "124px",
                  class: "preview",
                  title: file.name
              }));
      };
    })(file);
    reader.readAsDataURL(file);
  });
});


$(function(){
  $(document).on('input', function(){
    var data = $('.price-input').val();
    var fee = (data - (Math.round(data * 0.9)))
    var gain = data - fee
    $('.a-container__main__price__box__upper__list__hyphen').html('¥' + fee);
    $('.a-container__main__price__box__upper__list__last__hyphen').html('¥' + gain);
    if (data < 300) {
      $('.a-container__main__price__box__upper__list__hyphen').html("-");
      $('.a-container__main__price__box__upper__list__last__hyphen').html("-");
    } else if (data > 9999999) {
      $('.a-container__main__price__box__upper__list__hyphen').html("-");
      $('.a-container__main__price__box__upper__list__last__hyphen').html("-");
    }
  })
})


// $(function(){
//   $('.price-input').on('input', function(){
//     var data = $('.price-input').val();
//     var fee = (data - (Math.round(data * 0.9)))
//     var gain = data - fee
//     $('.a-container__main__price__box__upper__list__hyphen').html('¥' + fee);
//     $('.a-container__main__price__box__upper__list__last__hyphen').html('¥' + gain);
//     if (data < 300) {
//       $('.a-container__main__price__box__upper__list__hyphen').html("-");
//       $('.a-container__main__price__box__upper__list__last__hyphen').html("-");
//     } else if (data > 9999999) {
//       $('.a-container__main__price__box__upper__list__hyphen').html("-");
//       $('.a-container__main__price__box__upper__list__last__hyphen').html("-");
//     }
//   })
// })


// ！ドラッグアンドドロップは後回しなのでコメントアウト中！


// import Dropzone from 'dropzone'


// let myDropzone = {}

// dropzoneSetting()

// /**
//  * dropzone.jsの処理
//  * 
//  */
// async function dropzoneSetting() {
//     Dropzone.autoDiscover = false

//     //最大ファイルアップロードサイズ
//     let maxFileSize = 10

//     //企業ID
//     let clientId = $('#client-id').data('clientId')

//     myDropzone = new Dropzone('.image-upload-area', {
//         url: '/api/v1/facility-image/upload/',
//         params: {
//             client_id: clientId,
//         },
//         dictDefaultMessage: 'ここにファイルをドラッグ＆ドロップ、または、クリックしてファイルを選択',
//         dictRemoveFile: '',
//         dictCancelUpload: '',
//         dictFileTooBig: 'ファイルサイズは' + maxFileSize + 'MBまで',
//         dictInvalidFileType: 'JPEG,PNGのみ可能',
//         addRemoveLinks: true,
//         maxFilesize: maxFileSize,
//         acceptedFiles: 'image/*',
//         parallelUploads: 1,
//         uploadMultiple: false,
//         previewsContainer: '.visualizacao', 
//         previewTemplate : $('.preview').html(),
//         renameFile: (file) => {
//             let fileName = new Date().getTime() + '_' + file.size

//             let extension = file.name.split('.').pop()
//             return fileName + '.' + extension
//         },
//     })

//     //アップロードに失敗した場合
//     myDropzone.on('error', async function(file, errorMessage) {
//         //ファイル数が多い場合
//         if(errorMessage === '最大8ファイルまでしか添付できません') {
//             myDropzone.removeFile(file)
//             swal('', errorMessage, 'warning')
//         } else if(errorMessage === 'セッションが切れました。もう一度ログインしてください。') {
//             await swal('', 'セッションが切れました。もう一度ログインし直してください。', 'warning')
//             location.replace(location.href)
//         }
//     })

//     //画像を削除したときに、サーバー上のファイルも削除する
//     myDropzone.on("removedfile", function(file) {
//         let imageId = file.imageId

//         //画像ID
//         axios.get('/api/v1/facility-image/delete-by-image-id/' + imageId)
//             .catch((error) => {
//                 console.log(error)
//             })
//     })

//     //既存の画像が表示されたときに情報を追加する
//     myDropzone.on("addedfile", function(file) {
//         $('.dz-preview').each(function() {
//             let imageId = $(this).children('.caption-button').data('imageId')

//             //画像IDが設定されていない場合のみ追加する
//             if(!imageId) {
//                 let imageId = file.imageId

//                 //今回追加した画像の場合は飛ばす
//                 if(!imageId) {
//                     return
//                 }

//                 $(this).children('.caption-button').data('imageId', imageId)

//                 let caption = file.caption
//                 $(this).children('.caption').val(caption)

//                 $(this).parents('li').data('imageId', imageId)
//             }
//         })
//     })

//     //新しい画像がアップロードされたときに、画像IDを追加する
//     myDropzone.on("success", function(file, response) {
//         $('.dz-preview').each(function() {
//             let existImageId = $(this).children('.caption-button').data('imageId')

//             //画像IDが設定されていない場合のみ追加する
//             if(!existImageId) {
//                 let imageId = response
//                 $(this).children('.caption-button').data('imageId', imageId)
//                 $(this).parents('li').data('imageId', imageId)
//             }
//         })
//     })

//     //すでに保存されている画像を表示する
//     $('.exist-image').each(function() {
//         let path = $(this).data('path')
//         let info = {
//             name: '',
//             size: '',
//             imageId: $(this).data('id'),
//             caption: $(this).data('caption')
//         }
//         myDropzone.emit("addedfile", info)

//         if(path) {
//             myDropzone.emit("thumbnail", info, path)
//         } else {
//             let base64 = 'data:' + $(this).data('type') + ';base64,' + $(this).data('binary')
//             myDropzone.emit("thumbnail", info, base64)
//         }

//         myDropzone.emit("complete", info)
//     })

//     //画像の説明文を登録
//     $(document).on('click', '.caption-button', function() {
//         let input = $(this).prev()

//         axios.post('/api/v1/facility-image/save-caption/', {
//                 caption: input.val(),
//                 image_id: $(this).data('imageId'),
//             })
//             .then(() => {
//                 swal('', '説明文を登録しました', 'success')
//             })
//             .catch((error) => {
//                 swal('', '説明文の登録に失敗しました', 'error')
//                 console.log(error)
//             })
//     })
// }