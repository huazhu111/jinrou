const fs = require('fs');
const readline = require('readline');
const os = require('os');

let inf = fs.readFileSync('theme.csv',{encoding:'utf8'});
let outf = fs.createWriteStream('out.txt');
let infs = inf.split(/\r?\n/ig);
infs.forEach((v)=>{
    let vs = v.split(',');
    //roumaji
    outf.write(vs[2] + ':' + os.EOL);
    outf.write('\t' + 'avatar:' + "\"" + vs[0] + "\"" + os.EOL);
    outf.write('\t' + 'name:' + "\"" + vs[1] + "\"" + os.EOL);
    outf.write('\t' + 'prize:' + "\"" + vs[3] + "\"" + os.EOL);
});

function space(count){
    let s = "";
    for(let i = 0;i<count;i++){
        s += " ";
    }
    return s;
}