USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLDebug]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GLDebug] @BatNbr VARCHAR(10),
	@Sol_User varchar(10) as

delete from Wrkrelease where useraddress = 'GLDebug'

insert into wrkrelease (batnbr, module, useraddress)
values (@Batnbr, 'GL', 'GLDebug')

exec pp_01400 'GLDebug', @Sol_User

select * from Wrkrelease where useraddress = 'GLDebug'
select * from Wrkreleasebad where useraddress = 'GLDebug'

delete from Wrkrelease where useraddress = 'GLDebug'
delete from Wrkreleasebad where useraddress = 'GLDebug'

Select 'Debug complete.'
GO
