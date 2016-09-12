/**
 * Created by chotoxautinh on 9/9/16.
 */
// var encoded = 'data:image/png;base64,iVBORw0KGgoAA...5CYII=';
var encoded = 'data:image/;base64,iVBORw0KGgoAA...5CYII='
let base64Data = encoded.replace(/^data:image\/(jpg|jpeg|png);base64,/, "");
let mime = encoded.match(/^data:image\/(jpg|jpeg|png);base64,/);

let ext = mime;

console.log(base64Data);
console.log(ext);