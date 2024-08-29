import logging


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    filename='log.txt',
    filemode='w'
)

logging.debug("debug msg")
logging.info("info msg")
logging.warning("warning msg")
logging.error("error msg")
logging.critical("critical msg")


test_logger = logging.getLogger('test_logger')

test_logger.error("what is it")