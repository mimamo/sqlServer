USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjemploy_sUserid]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjemploy_sUserid] @parm1 varchar (50)  as
select *
from PJEMPLOY
where PJEMPLOY.user_id = @parm1
GO
