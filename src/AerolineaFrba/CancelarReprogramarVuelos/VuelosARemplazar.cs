﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AerolineaFrba.CancelarReprogramarVuelos
{
    public partial class VuelosARemplazar : Form
    {
        
        public VuelosARemplazar()
        {
            InitializeComponent();
        }

        private void cargaVentana_load(object sender, EventArgs e)
        {
            this.dataGridListadoVuelos.DataSource = this.vuelosVinculados();
            this.dataGridListadoVuelos.Columns[0].Visible = false;
            this.dataGridListadoVuelos.Columns[6].Visible = false;
            this.dataGridListadoVuelos.Columns[7].Visible = false;
            this.dataGridListadoVuelos.Columns[8].Visible = false;
        }

   
        private void darDeBajaLosVuelosDe(DataTable tabla)
        {
            foreach (DataRow vuelo in tabla.Rows)
            {
                funcionesComunes.darDebajaVuelo(Int32.Parse(vuelo[0].ToString()));
            }
        }

        private void buttonTerminar_Click(object sender, EventArgs e)
        {
            DialogResult dialogResult = MessageBox.Show("Se cancelaran todos los vuelos que no se remplazaron ¿Esta Seguro?", "Terminar", MessageBoxButtons.YesNo);
            if (dialogResult == DialogResult.Yes)
            {
                DataTable tabla = (DataTable)this.dataGridListadoVuelos.DataSource;
                this.darDeBajaLosVuelosDe(tabla);
                if (this.textBoxTipo.Text != "0")
                    funcionesComunes.darDeBajaAeronave(this.textBoxTipoIdAero.Text);
                funcionesComunes.volverAMenuPrincipal();
            }
        }

        private void botonRemplazar_Click(object sender, EventArgs e)
        {   
            DataTable aeronavesDisponibles = this.obtenerAeronavesDisponibles();
            Int32 cantidadDisponible = aeronavesDisponibles.Rows.Count;
            if (cantidadDisponible > 0){
                Form seleccionarAeronave = new CancelarReprogramarVuelos.SeleccionarAeronave(aeronavesDisponibles);
                ((TextBox)seleccionarAeronave.Controls["textBoxIdVuelo"]).Text = this.dataGridListadoVuelos.SelectedCells[0].Value.ToString();
                funcionesComunes.deshabilitarVentanaYAbrirNueva(seleccionarAeronave);
            }else{
                MessageBox.Show("No hay ninguna aeronave que pueda ser usada como remplazo");
                Int32 id = Int32.Parse(dataGridListadoVuelos.SelectedCells[0].Value.ToString());
                funcionesComunes.darDebajaVuelo(id);
                
            }
        }

        private DataTable obtenerAeronavesDisponibles()
        {
            String fechaSalida = String.Format("{0:yyyyMMdd HH:mm:ss}", 
                Convert.ToDateTime(this.dataGridListadoVuelos.SelectedCells[1].Value).AddHours(-1));
            String fechaLlegadaEstimada = String.Format("{0:yyyyMMdd HH:mm:ss}", 
                Convert.ToDateTime(this.dataGridListadoVuelos.SelectedCells[3].Value).AddHours(1));

            return SqlConnector.obtenerTablaSegunConsultaString(@"SELECT a.ID, a.MATRICULA, a.MODELO FROM AERO.vuelos v, 
                AERO.aeronaves a where v.AERONAVE_ID = a.ID and a.ID != " + 
                Int32.Parse(this.textBoxTipoIdAero.Text) + @" and a.ID not in (select naves.ID 
                from AERO.aeronaves naves, AERO.vuelos vu where vu.AERONAVE_ID = naves.ID and 
                (vu.FECHA_SALIDA between convert(datetime, '" + fechaSalida + @"',109) and 
                convert(datetime, '" + fechaLlegadaEstimada + @"',109) and vu.FECHA_LLEGADA between 
                convert(datetime, '" + fechaSalida + @"',109) and convert(datetime, '" + 
                fechaLlegadaEstimada + @"',109) and vu.FECHA_LLEGADA_ESTIMADA between 
                convert(datetime, '" + fechaSalida + @"',109) and convert(datetime, '" + 
                fechaLlegadaEstimada + @"',109)) or v.INVALIDO = 1 or naves.BAJA IS NOT NULL or 
                naves.TIPO_SERVICIO_ID != " + 
                Int32.Parse(this.dataGridListadoVuelos.SelectedCells[8].Value.ToString()) +
                ") group by a.ID, a.MATRICULA, a.MODELO order by a.ID, a.MATRICULA, a.MODELO");
        }
        private DataTable vuelosVinculados()
        {
            String id = this.textBoxTipoIdAero.Text;
            return SqlConnector.obtenerTablaSegunConsultaString(@"SELECT v.ID as Id,v.FECHA_SALIDA as 'Fecha Salida',v.FECHA_LLEGADA as 'Fecha Llegada'
                        ,v.FECHA_LLEGADA_ESTIMADA as 'Fecha Estimada',r.CODIGO as 'Codigo Ruta',t.NOMBRE as Servicio, v.AERONAVE_ID as Aeronave,v.RUTA_ID as RutaID,
                        r.TIPO_SERVICIO_ID as IdServicio
                        FROM AERO.vuelos v
                        join AERO.rutas r on r.ID = v.Ruta_ID
                        join AERO.tipos_de_servicio t on t.ID = r.TIPO_SERVICIO_ID
                        where v.AERONAVE_ID =" + id + " AND v.INVALIDO = 0 AND v.FECHA_SALIDA > CURRENT_TIMESTAMP order by 2");
        }

        private void recarga_enter(object sender, EventArgs e)
        {
            this.dataGridListadoVuelos.DataSource = this.vuelosVinculados();
        }
        
    }
}