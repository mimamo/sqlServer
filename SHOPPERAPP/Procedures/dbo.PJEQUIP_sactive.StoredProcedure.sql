USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQUIP_sactive]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQUIP_sactive] @parm1 varchar (10)  as
select * from PJEQUIP
where equip_id like @parm1
and status = 'A'
order by equip_id
GO
