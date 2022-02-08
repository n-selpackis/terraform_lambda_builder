const AWS = require("aws-sdk");
AWS.config.update({region: process.argv[3]});
const codebuild = new AWS.CodeBuild();

exports.handler = async () => {
	const projectName = process.argv[2];
	const {build} = await codebuild
		.startBuild({projectName})
		.promise();
	const wait_until_complete = process.argv[3];
	while (wait_until_complete === true) {
		const {builds} = await codebuild
			.batchGetBuilds({
				ids: [build.id],
			})
			.promise();
		for (const iterator of builds) {
			const id = iterator.id;
			if (id == build.id && !iterator.buildComplete) {
				await new Promise((resolve) =>
					setTimeout(resolve, 5000)
				);
				break;
			}
			if (iterator.buildStatus == "FAILED") {
				throw new Error(`${id} ${iterator.buildStatus}`);
			}
			await new Promise((resolve) =>
				setTimeout(resolve, 5000)
			);
			return iterator;
		}
	}
};

this.handler();
