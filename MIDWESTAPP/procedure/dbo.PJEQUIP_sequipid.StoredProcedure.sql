USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQUIP_sequipid]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQUIP_sequipid] @parm1 varchar (10)  as
select * from PJEQUIP
where equip_id = @parm1
order by equip_id
GO
