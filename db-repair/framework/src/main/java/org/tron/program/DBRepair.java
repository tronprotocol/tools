package org.tron.program;

import com.beust.jcommander.JCommander;
import lombok.extern.slf4j.Slf4j;
import org.tron.capsule.AbiCapsule;
import org.tron.capsule.ContractCapsule;
import org.tron.utils.ByteArray;
import org.tron.utils.CommonParameter;
import org.tron.utils.LevelDbDataSourceImpl;

@Slf4j(topic = "Repair")
public class DBRepair {

  public static CommonParameter PARAMETER = new CommonParameter();

  private static final byte[] ABI_MOVE_DONE = "ABI_MOVE_DONE".getBytes();

  private static int count;

  public static void doRepair() {
    logger.info("Start to repair database");
    LevelDbDataSourceImpl contractStore = new LevelDbDataSourceImpl(
        PARAMETER.getOutputDirectory(), "contract");
    LevelDbDataSourceImpl abiStore = new LevelDbDataSourceImpl(
        PARAMETER.getOutputDirectory(), "abi");
    contractStore.initDB();
    abiStore.initDB();
    abiStore.iterator().forEachRemaining(e -> {
      AbiCapsule abiCapsule = new AbiCapsule(e.getValue());
      ContractCapsule contractCapsule = new ContractCapsule(contractStore.getData(e.getKey()));
      contractStore.putData(e.getKey(), contractCapsule.getInstance().toBuilder()
          .setAbi(abiCapsule.getInstance()).build().toByteArray());
      count += 1;
      if (count % 50_000 == 0) {
        logger.info("Repairing database, current count: {}", count);
      }
    });
    LevelDbDataSourceImpl dynamicPropertiesStore = new LevelDbDataSourceImpl(
        PARAMETER.getOutputDirectory(), "properties");
    dynamicPropertiesStore.initDB();
    dynamicPropertiesStore.putData(ABI_MOVE_DONE, ByteArray.fromLong(0));
    logger.info("Repairment completed!");

    contractStore.closeDB();
    abiStore.closeDB();
    dynamicPropertiesStore.closeDB();
    logger.info("Database closed!");
  }

  public static void main(String[] args) {
    JCommander.newBuilder().addObject(PARAMETER).build().parse(args);
    doRepair();
  }
}
