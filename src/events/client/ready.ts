import { Client } from "discord.js-selfbot-v13";
import logger from "../../utils/logger.js";

export async function handleReady(client: Client): Promise<void> {
	if (client.user) {
		logger.info(`${client.user.tag} is ready`);
	}
}