USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PJPROJ_all]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[xAlt_PJPROJ_all] @parm1 varchar (16)  as
select * from xAlt_PJPROJ
where DefaultType like @parm1
order by DefaultType
GO
