USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjemploy_scount]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjemploy_scount] @parm1 smalldatetime   as
select Count(*) from pjemploy
where   em_id08 = @parm1
GO
