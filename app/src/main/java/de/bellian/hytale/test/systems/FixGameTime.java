package de.bellian.hytale.test.systems;

import java.time.Instant;
import java.util.logging.Logger;

import javax.annotation.Nonnull;

import com.hypixel.hytale.server.core.modules.time.WorldTimeResource;
import com.hypixel.hytale.server.core.universe.world.World;
import com.hypixel.hytale.server.core.universe.world.storage.EntityStore;
import com.hypixel.hytale.component.system.tick.TickingSystem;
import com.hypixel.hytale.component.Store;

public class FixGameTime extends TickingSystem<EntityStore> {
    int ticks = 0;
    int phase = -1;
    Instant gameTime = Instant.MIN;

    public FixGameTime() {
    }

    public void tick(float dt, int systemIndex, @Nonnull Store<EntityStore> store) {
        this.ticks++;
        if (ticks < 1000) {
            if (this.phase == -1) {
                WorldTimeResource worldTimeResource = (WorldTimeResource) store
                        .getResource(WorldTimeResource.getResourceType());

                World world = ((EntityStore) store.getExternalData()).getWorld();
                worldTimeResource.setDayTime(0.5, world, store);
                this.phase = worldTimeResource.getMoonPhase();  
                this.gameTime = worldTimeResource.getGameTime();
            }

            return;
        }
        this.ticks = 0;

        WorldTimeResource worldTimeResource = (WorldTimeResource) store
                .getResource(WorldTimeResource.getResourceType());

        World world = ((EntityStore) store.getExternalData()).getWorld();
        worldTimeResource.setGameTime(gameTime, world, store);
        // worldTimeResource.setDayTime(0.5, world, store);
        Logger.getLogger("FixGameTime").info("Fixed game time to " + gameTime);
    }
}
