USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJIMPEXP_sbytype]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJIMPEXP_sbytype] @parm1 varchar (2) , @parm2 varchar (8)  as
select * from PJIMPEXP
where
	map_type = @parm1 and
	map_id like @parm2
	order by map_type, map_id
GO
