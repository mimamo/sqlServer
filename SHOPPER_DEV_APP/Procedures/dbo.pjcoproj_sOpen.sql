USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcoproj_sOpen]    Script Date: 12/16/2015 15:55:26 ******/
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
