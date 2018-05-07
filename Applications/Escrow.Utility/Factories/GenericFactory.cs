using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using Escrow.Utility.Interfaces;
using System.Reflection;
using System.Configuration;
using System.Data.SqlClient;
using System.Transactions;
using System.Data;
using System.Net.NetworkInformation;
using System.Net;
using System.Net.Sockets;
using System.Runtime.CompilerServices;

namespace Escrow.Utility.Factories
{
    public abstract class GenericFactory<C, T> :
       IGenericFactory<T>
        where T : class
        where C : DbContext, new()
    {
        private C _entities = new C();

        SqlConnection sqlConn;
        SqlCommand cmd;
        protected C Context
        {

            get { return _entities; }
            set { _entities = value; }
        }

        public virtual IQueryable<T> GetAll()
        {

            IQueryable<T> query = _entities.Set<T>();
            return query;
        }

        public IQueryable<T> FindBy(System.Linq.Expressions.Expression<Func<T, bool>> predicate)
        {

            IQueryable<T> query = _entities.Set<T>().Where(predicate);
            return query;
        }

        public bool HasData(System.Linq.Expressions.Expression<Func<T, bool>> predicate)
        {
            return FindBy(predicate).Count() > 0;
        }

        public virtual bool IsDuplicate(T entity)
        {
            return false;
        }

        public virtual void Add(T entity)
        {
            _entities.Set<T>().Add(entity);
        }

        public T GetById(decimal id)
        {
            return _entities.Set<T>().Find(id);
        }

        public T GetById(string id)
        {
            return _entities.Set<T>().Find(id);
        }

        public virtual void Delete(T entity)
        {

            _entities.Set<T>().Remove(entity);
        }

        public virtual void Delete(System.Linq.Expressions.Expression<Func<T, bool>> predicate)
        {
            IQueryable<T> list = _entities.Set<T>().Where(predicate);
            foreach (var entity in list)
            {
                _entities.Set<T>().Remove(entity);
            }
            //_entities.SaveChanges();
        }

        public virtual void Edit(T entity)
        {

            _entities.Entry(entity).State = EntityState.Modified;
        }

        public virtual void Save()
        {
            _entities.SaveChanges();
        }

        public virtual void Save(T entity)
        {
            _entities.SaveChanges();
        }

        /// <summary>
        /// Investor financial transaction
        /// </summary>
        /// <param name="id"></param>
        /// <param name="financial_ledger_type_id"></param>
        /// <param name="membership_id"></param>
        /// <param name="changed_user_id"></param>
        public virtual void Save(string id, decimal financial_ledger_type_id, decimal membership_id, string changed_user_id)
        {
            _entities.SaveChanges();
        }

        //public virtual void Save(T entity, bool isWithLog)
        //{
        //    if(isWithLog)
        //    {
        //        string newValue = "";
        //        string connstr = ConfigurationManager.ConnectionStrings["SecurityConnectionString"].ConnectionString;
        //        string controller = "";
        //        string oldValue = "";

        //        Type myType = entity.GetType();
        //        IList<PropertyInfo> props = new List<PropertyInfo>(myType.GetProperties());

        //        decimal membership_id = 0;
        //        string changed_user_id = "";

        //        foreach (PropertyInfo prop in props)
        //        {
        //            if (prop.Name == "membership_id")
        //            {
        //                membership_id = Convert.ToDecimal(prop.GetValue(entity, null));
        //            }
        //            else if(prop.Name == "changed_user_id")
        //            {
        //                changed_user_id = prop.GetValue(entity, null).ToString();
        //            }
        //        }

        //        var changeSet = _entities.ChangeTracker.Entries();

        //        if (changeSet != null)
        //        {
        //            try
        //            {
        //                foreach (var change in changeSet.Where(x => x.State != EntityState.Unchanged))
        //                {
        //                    if (change.State == EntityState.Added)
        //                    {
        //                        newValue = EntityToString(entity, true);
        //                        SaveCRUDLog(changed_user_id, controller, "Insert", oldValue, newValue, membership_id);
        //                    }
        //                    else if (change.State == EntityState.Modified)
        //                    {
        //                        //var originalValues = EntityState.GetObjectStateEntry(entity).OriginalValues;
        //                        //var originalEntity = context.MyEntities.AsNoTracking().Where(me => me.MyEntityID == myEntity.MyEntityID).FirstOrDefault();

        //                        var originalEntity = change.OriginalValues;

        //                        //foreach (string prop in change.OriginalValues.PropertyNames)
        //                        //{
        //                        //    object currentValue = change.CurrentValues[prop];
        //                        //    object originalValue = change.GetDatabaseValues().GetValue<string>(prop);
        //                        //    //if (!currentValue.Equals(originalValue))
        //                        //    //{
        //                        //    //    AuditLogs.Add(new AuditLog
        //                        //    //    {
        //                        //    //        TableName = entityName,
        //                        //    //        State = state,
        //                        //    //        ColumnName = prop,
        //                        //    //        OriginalValue = Convert.ToString(originalValue),
        //                        //    //        NewValue = Convert.ToString(currentValue),
        //                        //    //    });
        //                        //    //}
        //                        //}

        //                        string ty = "hgs";

        //                        var changeInfo = _entities.ChangeTracker.Entries()
        //                                            .Where(t => t.State == EntityState.Modified)
        //                                            .Select(t => new
        //                                            {
        //                                                Original = t.OriginalValues.PropertyNames.ToDictionary(pn => pn, pn => t.OriginalValues[pn]),
        //                                                Current = t.CurrentValues.PropertyNames.ToDictionary(pn => pn, pn => t.CurrentValues[pn]),
        //                                            });
        //                    }
        //                    else if(change.State == EntityState.Deleted)
        //                    {

        //                    }
        //                }
        //                //_entities.SaveChanges();
        //            }
        //            catch (Exception)
        //            {
                        
        //                throw;
        //            }
        //        }

        //    }
        //    else
        //    {
        //        _entities.SaveChanges();
        //    }
        //}


        public virtual void Save(bool isWithLog)
        {
            if (isWithLog)
            {
                try
                {
                    var changeSet = _entities.ChangeTracker.Entries();
                    foreach (var change in changeSet.Where(x => x.State != EntityState.Unchanged))
                    {
                        string newValue = "";
                        string controller = "";
                        string oldValue = "";

                        Type myType = change.Entity.GetType();
                        IList<PropertyInfo> props = new List<PropertyInfo>(myType.GetProperties());

                        decimal membership_id = 0;
                        string changed_user_id = "";

                        foreach (PropertyInfo prop in props)
                        {
                            if (prop.Name == "membership_id")
                            {
                                membership_id = Convert.ToDecimal(prop.GetValue(change.Entity as T, null));
                            }
                            else if (prop.Name == "changed_user_id")
                            {
                                changed_user_id = prop.GetValue(change.Entity as T, null).ToString();
                            }
                        }

                        if (changeSet != null)
                        {
                            if (change.State == EntityState.Added)
                            {
                                newValue = EntityToStringForNewValue(change.Entity as T, true);
                                SaveCRUDLog(changed_user_id, controller, "Insert", oldValue, newValue, membership_id);
                            }
                            else if (change.State == EntityState.Modified)
                            {
                                newValue = EntityToStringForNewValue(change.Entity as T, true);
                                oldValue = EntityToStringForOldValue(change.Entity as T, true, change);
                                SaveCRUDLog(changed_user_id, controller, "Edit", oldValue, newValue, membership_id);
                            }
                            else if (change.State == EntityState.Deleted)
                            {
                                oldValue = EntityToStringForOldValue(change.Entity as T, true, change);
                                SaveCRUDLog(changed_user_id, controller, "Delete", oldValue, newValue, membership_id);
                            }
                        }
                    }
                    _entities.SaveChanges();
                }
                catch (Exception)
                {

                    throw;
                }

            }
            else
            {
                _entities.SaveChanges();
            }
        }

        private void SaveCRUDLog(string changed_user_id, string controller, string action, string old_value, string new_value, decimal membership_id)
        {
            sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["SecurityConnectionString"].ConnectionString);

            SqlCommand cmd = new SqlCommand();

            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "dbo.isp_crud_log";

                    cmd.Parameters.Add("@UserId", SqlDbType.VarChar).Value = changed_user_id;

                    cmd.Parameters.Add("@login_date", SqlDbType.DateTime).Value = DateTime.Now;

                    string macAddr =
                            (
                                from nic in NetworkInterface.GetAllNetworkInterfaces()
                                where nic.OperationalStatus == OperationalStatus.Up
                                select nic.GetPhysicalAddress().ToString()
                            ).FirstOrDefault();

                    string ipAddr = null;

                    if (System.Net.NetworkInformation.NetworkInterface.GetIsNetworkAvailable())
                    {
                        IPAddress host = Dns.GetHostEntry(Dns.GetHostName()).AddressList
                            .FirstOrDefault(ip => ip.AddressFamily == AddressFamily.InterNetwork);

                        ipAddr = host.ToString();
                    }

                    string pcName = System.Environment.MachineName;

                    cmd.Parameters.Add("@ip_address", SqlDbType.VarChar).Value = ipAddr;

                    cmd.Parameters.Add("@pc_address", SqlDbType.VarChar).Value = macAddr;

                    cmd.Parameters.Add("@pc_name", SqlDbType.VarChar).Value = pcName;

                    if (string.IsNullOrEmpty(controller) || controller == "undefined")
                        cmd.Parameters.Add("@controller", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@controller", SqlDbType.VarChar).Value = controller;

                    if (string.IsNullOrEmpty(action) || action == "undefined")
                        cmd.Parameters.Add("@action", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@action", SqlDbType.VarChar).Value = action;

                    if (string.IsNullOrEmpty(old_value) || old_value == "undefined")
                        cmd.Parameters.Add("@old_value", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@old_value", SqlDbType.VarChar).Value = old_value;

                    if (string.IsNullOrEmpty(new_value) || new_value == "undefined")
                        cmd.Parameters.Add("@new_value", SqlDbType.VarChar).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@new_value", SqlDbType.VarChar).Value = new_value;

                    cmd.Parameters.Add("@membership_id", SqlDbType.Decimal).Value = membership_id;

                    cmd.Connection = sqlConn;

                    sqlConn.Open();

                    cmd.ExecuteNonQuery();

                    scope.Complete();
                }
                catch (Exception)
                {
                    System.Transactions.Transaction.Current.Rollback();
                    throw;
                }
                finally
                {
                    sqlConn.Close();
                    sqlConn.Dispose();
                    scope.Dispose();
                }
            }
        }

        private string EntityToStringForNewValue(T entity, bool isSymbolic)
        {
            Type myType = entity.GetType();
            IList<PropertyInfo> props = new List<PropertyInfo>(myType.GetProperties());

            //"¤" symbol for table
            string str = "¤";

            //"»" symbol for separator
            //"©" symbol for property
            //"¢" symbol for starting bracket
            str += entity.GetType().Name + "»©¢";

            int i = 0;

            foreach (PropertyInfo prop in props)
            {
                if (!typeof(T).GetProperty(prop.Name).GetGetMethod().IsVirtual)
                {
                    if (i == 0)
                    {
                        if (prop.GetValue(entity, null) != null)
                        {
                            //"»" symbol for separator
                            str += prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + prop.GetValue(entity, null).ToString();

                            i++;
                        }
                        else
                        {
                            //"»" symbol for separator
                            str += prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + "";

                            i++;
                        }
                    }
                    else
                    {
                        if (prop.GetValue(entity, null) != null)
                        {
                            //"»" symbol for separator
                            str += "»" + prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + prop.GetValue(entity, null).ToString();
                        }
                        else
                        {
                            //"»" symbol for separator
                            str += "»" + prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + "";
                        }
                    }
                }
            }

            //"Ð" symbol for ending bracket
            str += "Ð";

            if (isSymbolic)
            {
                return str;
            }
            else
            {
                return str.Replace("¤", "Table = ").Replace("»", ", ").Replace("©", "Properties and Values ").Replace("¢", "{ ").Replace("‡", " = ").Replace("Ð", " }");
            }
        }

        private string EntityToStringForOldValue(T entity, bool isSymbolic, dynamic change)
        {
            Type myType = entity.GetType();
            IList<PropertyInfo> props = new List<PropertyInfo>(myType.GetProperties());

            //"¤" symbol for table
            string str = "¤";

            //"»" symbol for separator
            //"©" symbol for property
            //"¢" symbol for starting bracket
            str += entity.GetType().Name + "»©¢";

            int i = 0;



            var propertyValue = (dynamic)null;

            foreach (PropertyInfo prop in props)
            {
                if (!typeof(T).GetProperty(prop.Name).GetGetMethod().IsVirtual)
                {
                    if (i == 0)
                    {
                        if (prop.GetValue(entity, null) != null)
                        {
                            //"»" symbol for separator
                            str += prop.Name;
                            //"‡" symbol for equal

                            try
                            {
                                propertyValue = change.GetDatabaseValues().GetValue<dynamic>(prop.Name);
                            }
                            catch (Exception)
                            {
                                propertyValue = "";
                            }

                            str += "‡" + propertyValue.ToString();

                            i++;
                        }
                        else
                        {
                            //"»" symbol for separator
                            str += prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + "";

                            i++;
                        }
                    }
                    else
                    {
                        if (prop.GetValue(entity, null) != null)
                        {
                            //"»" symbol for separator
                            str += "»" + prop.Name;
                            //"‡" symbol for equal

                            try
                            {
                                propertyValue = change.GetDatabaseValues().GetValue<dynamic>(prop.Name);
                            }
                            catch (Exception)
                            {
                                propertyValue = "";
                            }

                            str += "‡" + propertyValue.ToString();
                        }
                        else
                        {
                            //"»" symbol for separator
                            str += "»" + prop.Name;
                            //"‡" symbol for equal
                            str += "‡" + "";
                        }
                    }
                }
            }

            //"Ð" symbol for ending bracket
            str += "Ð";

            if (isSymbolic)
            {
                return str;
            }
            else
            {
                return str.Replace("¤", "Table = ").Replace("»", ", ").Replace("©", "Properties and Values ").Replace("¢", "{ ").Replace("‡", " = ").Replace("Ð", " }");
            }
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {

            if (!this.disposed)
                if (disposing)
                    _entities.Dispose();

            this.disposed = true;
        }

        public void Dispose()
        {

            Dispose(true);
            GC.SuppressFinalize(this);
        }
        public virtual String getHTML()
        {
            return "";
        }

        public void Truncate(string tableName)
        {
            this.Context.Database.ExecuteSqlCommand("truncate table "+tableName);
        }

    }
}
