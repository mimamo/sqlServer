USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_PJPROJ_all]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[xCGS_PJPROJ_all] @parm1 varchar (16)  as
select * from xCGS_PJPROJ
where DefaultType like @parm1
order by DefaultType
GO
