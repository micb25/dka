
/* translations */
var LABEL = { 
    'EN': {
        'TRL_TITLE': 'Distribution of the transmission risk level in diagnosis keys',
        'TRL_SUBTITLE': '(last update: %DATE%; source: Corona-Warn-App)'
    }, 
    'DE': {
        'TRL_TITLE': 'Verteilung der TRL in Diagnoseschlüsseln',
        'TRL_SUBTITLE': '(Stand: %DATE%; Quelle: Corona-Warn-App)'
    } };

if (typeof lang === 'undefined') {
    /* fallback */
    var lang = 'EN';
}

Date.prototype.dateStr = function(l) {
    var str = this.toISOString();
    if ( l == 'DE' ) {
        return str.substring(8,10) + "." + str.substring(5,7) + "." + str.substring(0,4);
    } else {
        return str.substring(8,10) + "/" + str.substring(5,7) + "/" + str.substring(0,4);
    }
  };

/* TRL profile */

var TRL_sum_keys = 1;
var TRL_date = Date.now();

var plot_TRL_profile = {
    chart: {
      type: 'bar',
      width: '100%',
      height: '100%'
    },
    series: [{
      name: 'Transmission Risk Level',
      data: [0,0,0,0,0,0,0,0]
    }],
    xaxis: {
      categories: [8, 7, 6, 5, 4, 3, 2, 1],
      reversed: true
    },
    dataLabels: {
      enabled: true,
      style: {
            colors: ['#000000'],
            fontWeight: 'normal'
      },
      formatter: function(value, { seriesIndex, dataPointIndex, w }) {
        return Math.round((value/TRL_sum_keys+Number.EPSILON)*1000)/10.0 + "%";
      },
      offsetY: -25
    },
    colors: ['#72777e'],
    title: {
        text: LABEL[lang]['TRL_TITLE'],
        align: 'center'
    },
    subtitle: {
        text: LABEL[lang]['TRL_SUBTITLE'],
        align: 'center'
    },
    plotOptions: {
      bar: {
        dataLabels: {
          position: 'top'
        }
      },
      dataLabels: {
        enabled: true,
        style: {
            colors: ['#000000']
        }
      },
    }
  }

var chart = new ApexCharts(document.querySelector("#TRLchart"), plot_TRL_profile);
chart.render();

$.getJSON('./data_CWA/transmission_risk_level_statistics.json', function(response) { 
    sum_vals = response[response.length-1][1];
    TRL_sum_keys = sum_vals.reduce((a, b) => a + b, 0);
    var TRL_profile = [ sum_vals[7], sum_vals[6], sum_vals[5], sum_vals[4], sum_vals[3], sum_vals[2], sum_vals[1], sum_vals[0] ];
    chart.updateSeries( [ { data: TRL_profile } ] );

    TRL_date = new Date(response[response.length-2][0] * 1000);
    chart.updateOptions( { subtitle: { text: LABEL[lang]['TRL_SUBTITLE'].replace('%DATE%', TRL_date.dateStr(lang)) } } );
} );
