USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sMSPI]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sMSPI] @parm1 varchar (16)  as
select * from PJPROJ
where project like @parm1
and MSPInterface = 'Y'
order by project
GO
