USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJACTROL_dAll]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACTROL_dAll] @parm1 varchar (16)  as
Delete from PJACTROL
WHERE
project like @parm1
GO
