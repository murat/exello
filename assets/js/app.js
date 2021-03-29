// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import Sortable from 'sortablejs';

if (document.getElementById('board')) {
  // addToListEventHandler creates a card into a list
  // and prepend to the list
  function addToListEventHandler(e) {
    if (e.key === 'Enter' || e.keyCode === 13) {
      const cardInput = e.target;
      const list = cardInput.closest('.list');
      let data = {
        card: {
          title: cardInput.value,
          body: "",
          list_id: list.getAttribute('data-list-id'),
          position: 0
        }
      };
      fetch('/api/cards', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      }).
        then(resp => resp.json()).
        then(data => {
          const c = data.data;
          list.querySelector('.sortable-list').insertAdjacentHTML(
            "afterBegin",
            `<div data-card-id="${c.id}" class="sortable-card bg-white shadow rounded px-3 pt-3 pb-5 my-3 min-w-full border border-white">` +
            `<div class="flex justify-between">` +
            `<p class="text-gray-700 font-semibold font-sans tracking-wide text-sm">${c.title}</p>` +
            `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" class="handle opacity-10 cursor-move hover:opacity-40" style="max-width: 1rem; display: inline !important;" fill="currentColor">` +
            `<path stroke="#374151" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8V4m0 0h4M3 4l4 4m8 0V4m0 0h-4m4 0l-4 4m-8 4v4m0 0h4m-4 0l4-4m8 4l-4-4m4 4v-4m0 4h-4" />` +
            `</svg>` +
            `</div>` +
            `<div class="flex mt-4 justify-between items-center">` +
            `<span class="text-sm text-gray-600">${c.updated_at}</span>` +
            `</div>` +
            `</div>`
          );

          cardInput.value = ''
        });
    }
  }

  // add event listener to to all of the card inputs
  let addToListInputs = document.querySelectorAll('.list input.add-to-list');
  for (let i = 0; i < addToListInputs.length; i++) {
    const input = addToListInputs[i];
    input.addEventListener('keyup', addToListEventHandler, false)
  }

  document.querySelector('input.create-list').addEventListener('keyup', (e) => {
    if (e.key === 'Enter' || e.keyCode === 13) {
      const listInput = e.target;
      const insertPlace = listInput.closest('.list');
      const board = listInput.closest('#board');

      let data = {
        board_id: board.getAttribute('data-board-id'),
        list: {
          name: listInput.value,
          board_id: board.getAttribute('data-board-id')
        }
      };

      fetch('/api/lists', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      }).
        then(resp => resp.json()).
        then(data => {
          const l = data.data;
          insertPlace.insertAdjacentHTML(
            "beforeBegin",
            `<div data-list-id="${l.id}" class="list min-h-full w-96" style="min-width: 24rem;">` +
            `<div class="bg-gray-100 px-3 py-3 shadow column-width rounded mr-4">` +
            `<div class="text-gray-500 font-semibold font-sans tracking-wide text-sm relative flex justify-start">` +
            `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" class="handle opacity-10 cursor-move hover:opacity-40" style="max-width: 1rem; display: inline !important;" fill="currentColor">` +
            `<path stroke="#374151" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8V4m0 0h4M3 4l4 4m8 0V4m0 0h-4m4 0l-4 4m-8 4v4m0 0h4m-4 0l4-4m8 4l-4-4m4 4v-4m0 4h-4" />` +
            `</svg>` +
            `<p class="text-gray-700 font-semibold font-sans tracking-wide text-sm pl-3">${l.name}</p>` +
            `</div>` +
            `<input type="text" class="add-to-list mt-3 mb-3 min-w-full rounded" placeholder="Write something to do..."/>` +
            `<div data-list-id="${l.id}" class="sortable-list">` +
            `</div>` +
            `</div>` +
            `</div>`
          );

          const newList = board.querySelector('.sortable-list[data-list-id="' + l.id + '"]');
          makeSortableList(newList);

          board.querySelector('.list[data-list-id="' + l.id + '"] .add-to-list').addEventListener('keyup', addToListEventHandler, false);

          listInput.value = ''
        });
    }
  });

  document.querySelector('.list.unsortable').addEventListener('click', () => {
    document.querySelector('input.create-list').focus()
  });
  new Sortable(document.getElementById('board'), {
    animation: 150,
    handle: '.handle',
    filter: '.unsortable',
    onMove: (e) => {
      return e.related.className.indexOf('unsortable') === -1;
    },
    onEnd: (e) => {
      // console.log('list moved from', e.oldIndex, 'to', e.newIndex);
      let data = { list: { position: e.newIndex } };
      fetch('/api/lists/' + e.item.getAttribute('data-list-id'), {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });
    },
  });

  const makeSortableList = (sortable) => {
    new Sortable(sortable, {
      group: 'shared',
      handle: '.handle',
      animation: 150,
      onEnd: function (e) {
        // console.log('card moved from', e.from.getAttribute("data-list-id"), 'to', e.to.getAttribute("data-list-id"), 'with idx', e.oldIndex, 'as idx', e.newIndex);
        let data = {
          id: e.item.getAttribute('data-card-id'),
          card: {
            position: e.newIndex,
            list_id: e.to.getAttribute("data-list-id")
          }
        };
        fetch('/api/cards/' + e.item.getAttribute('data-card-id'), {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(data),
        });
      },
    });
  }

  var sortables = document.querySelectorAll('.sortable-list');
  for (let i = 0; i < sortables.length; i++) {
    makeSortableList(sortables[i]);
  }
}