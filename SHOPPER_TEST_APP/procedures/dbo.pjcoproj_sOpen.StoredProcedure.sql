USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcoproj_sOpen]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjcoproj_sOpen] @PARM1 varchar (16) as
select * from pjcoproj
Where
project = @PARM1 and
status1 <> 'A' and status1 <> 'C'
GO
