USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEQRATE_SEQUIPR]    Script Date: 12/21/2015 16:13:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEQRATE_SEQUIPR]  @parm1 varchar (10) , @parm2 varchar (16)   as
select * from PJEQRATE
where
equip_id  = @parm1 and
project like @parm2
order by equip_id, project, effect_date desc
GO
