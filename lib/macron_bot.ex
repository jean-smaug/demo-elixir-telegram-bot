defmodule MacronBot do
  @bot :Macron_Bot

  alias ExGram.Model

  use ExGram.Bot,
    name: @bot

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:text, text, msg}, context) do
    if String.match?(text, ~r/\?$/) do
      ExGram.delete_message(msg.chat.id, msg.message_id)

      answer(context, text,
        reply_markup: %ExGram.Model.InlineKeyboardMarkup{
          inline_keyboard: [
            [
              %ExGram.Model.InlineKeyboardButton{
                text: "Oui",
                callback_data: "Oui"
              }
            ],
            [
              %ExGram.Model.InlineKeyboardButton{
                text: "Non",
                callback_data: "Non"
              }
            ]
          ]
        }
      )
    end
  end

  def handle({:callback_query, callback_query}, context) do
    ExGram.edit_message_reply_markup(
      chat_id: callback_query.message.chat.id,
      message_id: callback_query.message.message_id
    )

    answer(context, "#{callback_query.data}, mais en même temps")
  end

  def handle({:command, "parle", _msg}, context) do
    answers = [
      "Si j'étais chômeur, je n'attendrais pas tout de l'autre, j'essaierais de me battre d'abord.",
      "Je suis maoïste, [...] un bon programme c'est ce qui marche.",
      "Le libéralisme est une valeur de gauche.",
      "Il y a dans cette société une majorité de femmes. Il y en a qui sont, pour beaucoup, illettrées.",
      "Les Tontons Flingueurs, c'est un de mes films préférés. \"On n'est pas venus pour beurrer les sandwichs\" : ma réplique préférée.",
      "Make our planet great again !",
      "Vous n'allez pas me faire peur avec votre t-shirt, la meilleure façon de se payer un costard c'est de travailler.",
      "Je ne vais pas interdire Uber et les VTC, ce serait les renvoyer vendre de la drogue à Stains.",
      "Vu la situation économique, ne plus payer les heures supplémentaires c'est une nécessité.",
      "La tranche d'impôt de Hollande à 75 % ? C'est Cuba sans le soleil.",
      "Quand des pays ont encore sept à huit enfants par femmes, vous pouvez décider d'y dépenser des milliards d'euros, vous ne stabiliserez rien.",
      "Le kwassa-kwassa pêche peu. Il amène du Comorien.",
      "Lorsque la politique n'est plus une mission mais une profession, les politiciens deviennent plus égoïstes que les fonctionnaires.",
      "Ne laissez pas la critique de l'UE à ceux qui le détestent.",
      "L'audiovisuel public est la honte de la République.",
      "La politique sociale, regardez : on met un pognon de dingue dans des minimas sociaux, les gens sont quand même pauvres.",
      "Je me bats sur le plan international pour qu'on arrive à faire baisser le prix du pétrole.",
      "Parce que c'est notre PROJEEEEET !!!"
    ]

    random_answer = answers |> Enum.random()

    answer(context, random_answer)
  end

  def handle({:command, "covid", _msg}, context) do
    {:ok, covid_summary} = Tesla.get("https://api.covid19api.com/summary")

    json = covid_summary.body |> Jason.decode!()
    global = json |> Map.get("Global")

    france =
      json
      |> Map.get("Countries")
      |> Enum.find(fn country -> country["Slug"] === "france" end)

    covid_answer = ~s"""
    🌍
    Nouveaux cas : #{global["NewConfirmed"]}
    Nouvelles morts : #{global["NewDeaths"]}
    Cas totaux : #{global["TotalConfirmed"]}
    Morts totales : #{global["TotalDeaths"]}

    🇫🇷
    Nouveaux cas : #{france["NewConfirmed"]}
    Nouvelles morts : #{france["NewDeaths"]}
    Cas totaux : #{france["TotalConfirmed"]}
    Morts totales : #{france["TotalDeaths"]}
    """

    answer(context, covid_answer)
  end

  def handle(_, _context) do
    # answer(context, "J'appelle à la responsabilité")
  end
end
