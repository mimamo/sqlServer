USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_sstatus]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_sstatus] as
select * from pjinvdet
WHERE bill_status IN ('U', 'S')
GO
