USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcosubh_sOpen]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjcosubh_sOpen] @PARM1 varchar (16) as
select * from pjcosubh
Where
project = @PARM1 and
status1 <> 'A' and status1 <> 'C'
GO
