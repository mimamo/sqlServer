USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjchargh_sstat]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure  [dbo].[pjchargh_sstat] @parm1 varchar (10)  as
select * from pjchargh
	       where    batch_id LIKE @parm1
	          and     pjchargh.batch_status =  'B'
order by batch_id
GO
