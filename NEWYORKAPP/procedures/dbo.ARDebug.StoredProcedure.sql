USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDebug]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARDebug] @BatNbr VARCHAR(10) as

delete from Wrkrelease where useraddress = 'ARDebug'
delete from Wrkreleasebad where useraddress = 'ARDebug'
delete from Wrk_TimeRange where useraddress = 'ARDebug'
delete from Wrk_SalesTax  where useraddress = 'ARDebug'
delete from WRK_GLTRAN where useraddress = 'ARDebug'

insert into wrkrelease (batnbr, module, useraddress)
values (@Batnbr, 'AR', 'ARDebug')

exec pp_08400 'ARDebug','Debug'

select * from Wrkrelease where useraddress = 'ARDebug'
select * from Wrkreleasebad where useraddress = 'ARDebug'

delete from Wrkrelease where useraddress = 'ARDebug'
delete from Wrkreleasebad where useraddress = 'ARDebug'

Select 'Debug complete.'
GO
