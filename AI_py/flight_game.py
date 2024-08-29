import pygame
import random

# 初始化 Pygame
pygame.init()

# 屏幕尺寸
screen_width = 480
screen_height = 600
screen = pygame.display.set_mode((screen_width, screen_height))

# 颜色
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)

# 加载图像
player_img = pygame.image.load("D:\\Programming\\Python\\AI_py\\pngs\\Ferris.png")
enemy_img = pygame.image.load("D:\\Programming\\Python\\AI_py\\pngs\\Ferris_Crab.png")
bullet_img = pygame.image.load("D:\\Programming\\Python\\AI_py\\pngs\\bullet.jpg")

# 缩放图像
player_img = pygame.transform.scale(player_img, (50, 40))
enemy_img = pygame.transform.scale(enemy_img, (40, 30))
bullet_img = pygame.transform.scale(bullet_img, (10, 20))

# 玩家飞船类
class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = player_img
        self.rect = self.image.get_rect()
        self.rect.centerx = screen_width // 2
        self.rect.bottom = screen_height - 10
        self.speed = 5

    def update(self):
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            self.rect.x -= self.speed
        if keys[pygame.K_RIGHT]:
            self.rect.x += self.speed
        if keys[pygame.K_UP]:
            self.rect.y -= self.speed
        if keys[pygame.K_DOWN]:
            self.rect.y += self.speed

        # 限制玩家飞船在屏幕内
        if self.rect.left < 0:
            self.rect.left = 0
        if self.rect.right > screen_width:
            self.rect.right = screen_width
        if self.rect.top < 0:
            self.rect.top = 0
        if self.rect.bottom > screen_height:
            self.rect.bottom = screen_height

# 子弹类
class Bullet(pygame.sprite.Sprite):
    def __init__(self, x, y):
        super().__init__()
        self.image = bullet_img
        self.rect = self.image.get_rect()
        self.rect.centerx = x
        self.rect.top = y
        self.speed = 7

    def update(self):
        self.rect.y -= self.speed
        if self.rect.bottom < 0:
            self.kill()

# 敌人类
class Enemy(pygame.sprite.Sprite):
    def __init__(self, speed_factor=1):
        super().__init__()
        self.image = enemy_img
        self.rect = self.image.get_rect()
        self.rect.x = random.randint(0, screen_width - self.rect.width)
        self.rect.y = random.randint(-100, -40)
        self.speedy = random.randint(2, 6) * speed_factor  # 敌人速度乘以速度因子

    def update(self):
        self.rect.y += self.speedy
        if self.rect.top > screen_height:
            self.rect.x = random.randint(0, screen_width - self.rect.width)
            self.rect.y = random.randint(-100, -40)
            self.speedy = random.randint(2, 6)

# 游戏主循环函数
def game_loop():
    # 创建游戏的Sprite组
    all_sprites = pygame.sprite.Group()
    bullets = pygame.sprite.Group()
    enemies = pygame.sprite.Group()

    player = Player()
    all_sprites.add(player)

    for i in range(8):
        enemy = Enemy()
        all_sprites.add(enemy)
        enemies.add(enemy)

    # 初始化分数
    score = 0
    font = pygame.font.Font(None, 36)

    # 初始化游戏速度
    enemy_speed_factor = 1

    # 游戏主循环
    running = True
    while running:
        # 保持游戏速度
        pygame.time.Clock().tick(60)

        # 处理事件
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                return False  # 退出游戏
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    bullet = Bullet(player.rect.centerx, player.rect.top)
                    all_sprites.add(bullet)
                    bullets.add(bullet)

        # 更新
        all_sprites.update()

        # 检测子弹是否击中敌人
        hits = pygame.sprite.groupcollide(enemies, bullets, True, True)
        for hit in hits:
            score += 10  # 击毁一个敌人加10分
            enemy_speed_factor += 0.02  # 随着得分增加，敌人速度逐渐加快
            enemy = Enemy(speed_factor=enemy_speed_factor)
            all_sprites.add(enemy)
            enemies.add(enemy)

        # 检测玩家是否与敌人碰撞
        hits = pygame.sprite.spritecollide(player, enemies, False)
        if hits:
            return score  # 玩家与敌人碰撞，结束游戏循环，返回得分

        # 绘制
        screen.fill(BLACK)
        all_sprites.draw(screen)

        # 绘制得分
        score_text = font.render(f"Score: {score}", True, WHITE)
        screen.blit(score_text, (10, 10))

        pygame.display.flip()

# 显示游戏结束屏幕
def show_game_over_screen(score):
    screen.fill(BLACK)
    font = pygame.font.Font(None, 64)
    text = font.render(f"Game Over", True, RED)
    screen.blit(text, (screen_width // 2 - text.get_width() // 2, screen_height // 3))

    font = pygame.font.Font(None, 36)
    score_text = font.render(f"Final Score: {score}", True, WHITE)
    screen.blit(score_text, (screen_width // 2 - score_text.get_width() // 2, screen_height // 2))

    restart_text = font.render("Press R to Restart or Q to Quit", True, WHITE)
    screen.blit(restart_text, (screen_width // 2 - restart_text.get_width() // 2, screen_height // 2 + 40))

    pygame.display.flip()

    waiting = True
    while waiting:
        keys = pygame.key.get_pressed()
        if keys[pygame.K_q]:
            return False # 退出游戏

# 主程序入口
def main():
    while True:
        score = game_loop()
        if score is None:  # 检测到关闭窗口事件
            break
        if not show_game_over_screen(score):
            break

    pygame.quit()

if __name__ == "__main__":
    main()
