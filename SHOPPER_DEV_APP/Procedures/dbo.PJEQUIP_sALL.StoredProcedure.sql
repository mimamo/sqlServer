USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQUIP_sALL]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQUIP_sALL] @parm1 varchar (10)  as
select * from PJEQUIP
where equip_id like @parm1
order by equip_id
GO
