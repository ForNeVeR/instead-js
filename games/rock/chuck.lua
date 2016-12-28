-------------------------
-- Чак (ударник, гуляка)
-------------------------

room_chuck = room {
  nam = 'Гримёрка ударника',
  pic = pic 'img/chuck.jpg',
  way = { vroom('Выйти', 'dressrooms') },
  obj = {
    'chuck',
    obj {
      nam = 'сорочка',
      dsc = [[ Рядом на стуле висит мятая {сорочка}, валяется ]],
      act = [[ Нет уж, спасибо. ]],
    },
    'lighter',
    'analgin',
  },
  enter = function()
    if chuck._aim == 2 then
      set_music "mus/drum.ogg"
    else
      set_music('mus/ticking-clock.ogg')
    end
  end,
}

chuck = obj {
  nam = 'Чак',
  _is_musician = true,
  dsc = function(s)
    if s._aim ~= 2 then
      p [[ {Чак} лежит на кушетке, отвернувшись в угол и закрыв голову руками. ]]
    else
      p [[ Взъерошенный {Чак} сидит на кушетке, рассеянно оглядывая гримёрку, как будто видит её впервые. ]]
    end
  end,
  act = function(s)
    if s._aim ~= 2 then
      walk 'dlg_chuck'
    else
      walk 'dlg_chuck_ok'
    end
  end,
  used = function(s, w)
    if w == cup then
      if s._aim == 2 then
        p [[ Ему уже хватит. ]]
      else
        if cup:is_cocktail_ok() then
          p [[ Чак жадно выхлебал мой стаканчик, крякнул, и со взъерошенным, но уже довольно бодрым видом уселся на кушетку.
          То ли коктейль, не смотря на недостаток ингридиентов, всё-таки сработал, то ли ударник уже просто выспался. ]]
          s._aim = 2
          set_music "mus/drum.ogg"
        else
          p [[ Чак жадно выхлебал мой стаканчик и снова уткнулся в угол. ]]
        end
        cup.obj:zap()
        inv():del('cup')
      end
    elseif s._aim ~= 2 then
      p [[ Ударник только мычит и пытается забиться в угол ещё глубже. ]]
    end
  end
}

dlg_chuck = dlg {
  nam = 'Ударник Чак',
  pic = pic 'img/chuck.jpg',
  enter = [[ Чак лежит на кушетке, отвернувшись в угол и закрыв голову руками. ]],
  hideinv = true,
  talk = {
    {
      persist = true,
      [[ Чак, что с тобой? ]],
      act = function()
        if (rnd(4) ~= 1) then
          p [[ Ударник только мычит и пытается забиться в угол ещё глубже. ]]
          walk 'room_chuck'
        else
          p [[ -- У-у-у... Уй! Уйди-и-и-и... ]]
        end
      end,
      stage = 'decide',
      {
        [[ Тебе плохо? ]],
        act = [[ Ударник только мычит и пытается забиться в угол ещё глубже. ]],
      },
      {
        [[ Что-то случилось? ]],
        act = [[ Де-е-е... День рожде-е-ения. У друга-а-а... ай, больно... Ещё вчера... ]],
        stage = 'decide_2',
        {
          [[ Тебя побили? ]],
          act = [[ Ударник только мычит и пытается забиться в угол ещё глубже. ]],
        },
        {
          [[ Ты подрался? ]],
          act = [[ Ударник только мычит и пытается забиться в угол ещё глубже. ]],
        },
        {
          [[ Ты напился? ]],
          act = function()
            chuck._aim = 1
            p [[ -- Угу-у-у, и теперь башка трещи-и-ит! ]]
          end,
          {
            [[ Попробую что-нибудь придумать... ]]
          }
        },
      }
    },
  },
}

dlg_chuck_ok = dlg {
  nam = 'Ударник Чак',
  pic = pic 'img/chuck.jpg',
  hideinv = true,
  enter = [[ Чак глядит на меня с глуповатой улыбкой. ]],
  talk = {
    {
      persist = true,
      [[ Ну как ты? ]],
      act = [[ -- Готов к труду и обороне! ]],
    },
    {
      [[ Может ты сейчас как раз разбираешься в огненных пентаграммах? ]],
      cond = code [[ return sam._aim == 1 ]],
      act = function()
        p [[ -- Гы! Это опять что ли у гитары Сэма аура испортилась? Я знаю эту фишку -- просто выжги, скажем, паяльником ему эту стограмму... тьфу, пентаграмму. ]]
--        guitar._known = true
      end,
    },
  },
}
