import sqlite3
from sqlite3 import Error

class ServerDB():
    def __init__(self):
        self.conn = None

        sql_create_users_table = """ CREATE TABLE IF NOT EXISTS users (
                                    name text PRIMARY KEY,
                                    password text NOT NULL,
                                    bmi real
                                ); """
    
        self.create_connection(r'serverDB.db')
        self.create_table(sql_create_users_table)
        # self.create_user(('doe','999',45.2))
        # self.update_user((20.3,'adel'))
        # self.select_user_by_name(('adel'))
        # self.select_all_users()

    def create_connection(self,db_file):
        """ create a database connection to the SQLite database
        specified by db_file
        :param db_file: database file
        :return: Connection object or None
        """
        try:
            self.conn = sqlite3.connect(db_file)
            print(sqlite3.version)
        except Error as e:
            print(e)
        # finally:
        #     if self.conn:
        #         self.conn.close()


    def create_table(self,create_table_sql):
        """ create a table from the create_table_sql statement
        :param create_table_sql: a CREATE TABLE statement
        :return:
        """
        try:
            c = self.conn.cursor()
            c.execute(create_table_sql)
        except Error as e:
            print(e)

    def create_user(self,user):
        """
        Create a new project into the projects table
        :param user: (name:str,password:str,bmi:float)
        :return: user id
        """
        sql = ''' INSERT INTO users(name,password,bmi)
                VALUES(?,?,?) '''
        cur = self.conn.cursor()
        try:
            cur.execute(sql, user)
            self.conn.commit()
            # print(f'name: {cur.lastrowid}') 
            return cur.lastrowid
        except sqlite3.IntegrityError as e:
            print(e)



    def update_user(self, user):
        """
        update bmi of a user
        :param user: (bmi:float,name:str)
        :return: 
        """
        sql = ''' UPDATE users
                SET bmi = ? 
                WHERE name = ?'''
        cur = self.conn.cursor()
        cur.execute(sql, user)
        self.conn.commit()


    def select_user_by_name(self, name):
        """
        Query users by name
        :param name: str
        :return: the row as a triple (name,pasword,bmi)
        """
        
        cur = self.conn.cursor()
        cur.execute("SELECT * FROM users WHERE name=?", (name,))

        rows = cur.fetchall() # this should be a single row since iam fetching using a unique identifier  

        try:
            print(rows[0])
            return rows[0]
        except IndexError as e:
            return 'notFound'
        
    def select_all_users(self):
        """
        Query all rows in the users table
        :return:
        """
        cur = self.conn.cursor()
        cur.execute("SELECT * FROM users")

        rows = cur.fetchall()

        for row in rows:
            print(row)

    def delete_user(self,name):
        """
        Delete a user by user name
        :param name: name, of the user
        :return:
        """
        sql = 'DELETE FROM users WHERE name=?'
        cur = self.conn.cursor()
        try:
            cur.execute(sql, (name,))
            self.conn.commit()
        except:
            print('user does NOT exits')

    def delete_all_users(self):
        """
        Delete all rows in the users table
        :return:
        """
        sql = 'DELETE FROM users'
        cur = self.conn.cursor()
        cur.execute(sql)
        self.conn.commit()
        
if __name__ == '__main__':
    db = ServerDB()