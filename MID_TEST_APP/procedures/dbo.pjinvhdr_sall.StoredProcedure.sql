USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sall]    Script Date: 12/21/2015 15:49:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sall] @parm1 varchar (10)  as
select * from pjinvhdr where draft_num like @parm1
order by draft_num
GO
