USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLPostDebug]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GLPostDebug] @BatNbr CHAR(10), @Module CHAR(2) AS

   DELETE FROM WrkPost WHERE UserAddress = 'GLPostDebug'
   DELETE FROM WrkPostbad WHERE UserAddress = 'GLPostDebug'

   INSERT INTO WrkPost (Batnbr, Module, UserAddress, tstamp)
   VALUES (@Batnbr, @Module, 'GLPostDebug', NULL)

   EXEC pp_01520 'GLPostDebug', 'GLPostDebug'

   SELECT * FROM WrkPost WHERE UserAddress = 'GLPostDebug'
   SELECT * FROM WrkPostbad WHERE UserAddress = 'GLPostDebug'

   DELETE FROM WrkPost WHERE UserAddress = 'GLPostDebug'
   DELETE FROM WrkPostbad WHERE UserAddress = 'GLPostDebug'

   SELECT 'GLPostDebug Post Complete.'
GO
