USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_snebill]    Script Date: 12/21/2015 13:35:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_snebill] @PARM1 varchar (16) as
select * from pjinvdet
Where
project = @PARM1 and
(bill_status <> 'B' and bill_status <> ' ') and hold_status <> 'PG'
GO
