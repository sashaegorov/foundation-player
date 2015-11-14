describe 'Document data suite', ->
  it 'has no traces from players', ->
    expect($.data document.body, 'FoundationPlayers').toBeUndefined()
