USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjchargh_srange]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure  [dbo].[pjchargh_srange] @parm1 varchar (10) , @parm2 varchar (10) , @parm3 varchar (1) , @parm4 varchar (6)  as
select * from pjchargh
	where     pjchargh.batch_id between @parm1 and @parm2
	   and      pjchargh.batch_status =  @parm3
	   and      pjchargh.fiscalno = @parm4
order by pjchargh.batch_id
GO
