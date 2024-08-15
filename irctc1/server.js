const ping = require('ping');
const readline = require('readline');


async function pingServer(host, count = 10) {
    let res = await ping.promise.probe(host, {timeout:10,min_reply:count});
    if (res.alive) {3
        console.log(`Results for ${host}:`);
        console.log(`  Packet Loss: ${ res.packetLoss}%`);
        console.log(`  Average Latency: ${res.avg} ms`);
    } else {
        console.log(`Ping failed. ${host} is unreachable.\n`);
    }
}


function promptUser() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question("Enter the IP address or hostname of the server (or type 'exit' to quit): ", function(host) {
        if(host!='exit') {
            pingServer(host)
                .then(() => promptUser())
                .catch(err => console.error(`Error pinging server: ${err.message}`));
        }
    });
}


promptUser();
