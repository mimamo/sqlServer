USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQUIP_spk9]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQUIP_spk9] @parm1 varchar (250) , @parm2 varchar (10)  as
select * from PJEQUIP
where equip_id = @parm2
order by equip_id
GO
