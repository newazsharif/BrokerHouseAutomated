using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;

namespace Escrow.Utility.Interfaces
{
    public interface IGenericFactory<T> : IDisposable where T : class
    {

        IQueryable<T> GetAll();
        IQueryable<T> FindBy(Expression<Func<T, bool>> predicate);
        T GetById(decimal id);
        T GetById(string id);
        bool HasData(System.Linq.Expressions.Expression<Func<T, bool>> predicate);
        bool IsDuplicate(T entity);
        void Add(T entity);
        void Delete(T entity);
        void Delete(System.Linq.Expressions.Expression<Func<T, bool>> predicate);
        void Edit(T entity);
        void Save();
        void Save(T entity);
        void Save(string id, decimal financial_ledger_type_id, decimal membership_id, string changed_user_id);
        void Save(bool isWithLog);

        String getHTML();
        void Truncate(string tableName);
    }
}
