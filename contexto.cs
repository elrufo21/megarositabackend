private async void FrmNotaPedido_Load(object sender, EventArgs e)
        {
            cargarload();
            try
            {
                cliente = new ClientWebSocket();
                Uri ipservidor = new Uri(conexion.Cadena);
                await cliente.ConnectAsync(ipservidor, CancellationToken.None);
                await recibirMensaje();
            }
            catch (Exception ex)
            {
                ex.ToString();
                MessageBox.Show("Se desconecto del Servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                this.Close();
            }
        }

        public async void enviarB(string codigo)
        {
            try
            {
                string TexGuarda = string.Empty;
                TexGuarda = "Se Registro "+cmddocumento.Text+" Nro " + codigo.ToString() + " Monto S/ " + lbltotalpagar.Text;
                string mensaje = String.Format("{0}{1}|{2}|{3}", "- ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexGuarda);
                byte[] buffer = Encoding.Default.GetBytes(mensaje);
                ArraySegment<byte> data = new ArraySegment<byte>(buffer);
                await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
            }
            catch (Exception ex) {
                ex.ToString();
                MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        public async void enviarC()
        {
            try
            {
                string TexGuarda = string.Empty;
                TexGuarda = "Se Edito el Docu Nro " + lblidnota.Text + " Monto S/ " + lbltotalpagar.Text;
                string mensaje = String.Format("{0}{1}|{2}|{3}", "* ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexGuarda);
                byte[] buffer = Encoding.Default.GetBytes(mensaje);
                ArraySegment<byte> data = new ArraySegment<byte>(buffer);
                await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
            }
            catch (Exception ex) { ex.ToString(); MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        }

        public async void enviar()
        {
            try
            {
                string TexElimina = string.Empty;
                TexElimina = "Elimino el Docu Nro "+lblidnota.Text + " Monto S/ " + lbltotalpagar.Text;
                string mensaje = String.Format("{0}{1}|{2}|{3}", "_ ", DateTime.Now.ToString(), xPersonal.Replace('Ñ', 'N').ToString(), TexElimina);
                byte[] buffer = Encoding.Default.GetBytes(mensaje);
                ArraySegment<byte> data = new ArraySegment<byte>(buffer);
                await cliente.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
            }
            catch (Exception ex) { ex.ToString(); MessageBox.Show("El Servidor se desconecto favor de revisar el servidor", "AVISO", MessageBoxButtons.OK, MessageBoxIcon.Warning); }
        }
        private void FrmNotaPedido_FormClosing(object sender, FormClosingEventArgs e)
        {
            try
            {
                if (cliente != null && cliente.State.Equals(WebSocketState.Open))
                    cliente.CloseAsync(WebSocketCloseStatus.Empty, "", CancellationToken.None);
            }
            catch (Exception ex) { ex.ToString(); }
        }