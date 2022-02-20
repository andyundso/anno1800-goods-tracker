import {Controller} from "@hotwired/stimulus"
import * as Dracula from "graphdracula"

export default class extends Controller {
    connect() {
        fetch(`/islands/${this.element.dataset.islandId}/available_goods/${this.element.dataset.id}/graph`)
            .then(response => response.json())
            .then(response => {
                const graph = new Dracula.Graph();

                response.forEach(item => {
                    if (item.type === 'node') {
                        graph.addNode(item.id, {
                            render: this.renderShape,
                            ...item
                        })
                    } else {
                        graph.addEdge(item.from, item.to, {"font-size": "16px", label: item.label, directed: true})
                    }
                })

                new Dracula.Layout.Spring(graph);
                const renderer = new Dracula.Renderer.Raphael(this.element, graph, this.element.offsetWidth, this.element.offsetHeight)
                renderer.draw()
            })
    }

    renderShape(r, n) {
        let offset = 30;
        const set = r.set();
        set.push(r.image(n.image, -20, -20, 40, 40))

        set.push(r.text(0, offset, n.good_name).click(() => clickHandler(n.href)))
        offset += 10

        set.push(r.text(0, offset, n.island).click(() => clickHandler(n.href)))
        offset += 10

        if (n.production !== null) {
            set.push(r.text(0, offset, `Produktion: ${n.production}`).click(() => clickHandler(n.href)))
            offset += 10
        }

        if (n.consumption !== null) {
            set.push(r.text(0, offset, `Verbrauch: ${n.consumption}`).click(() => clickHandler(n.href)))
            offset += 10
        }

        if (n.sparse !== null) {
            set.push(r.text(0, offset, `Rest-Menge: ${n.sparse}`).click(() => clickHandler(n.href)))
        }

        return set;
    }
}

function clickHandler(href) {
    fetch(href, {
        headers: {
            Accept: "text/vnd.turbo-stream.html",
        },
    })
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
}
