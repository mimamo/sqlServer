USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ConsAggLev_CustID_SeqNbr]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ConsAggLev_CustID_SeqNbr]

@CustID varchar(15),
@SeqNbrMin smallint,
@SeqNbrMax smallint

AS

select * from ConsAggLev where CustID = @CustID and SeqNbr between @SeqNbrMin and @SeqNbrMax
order by CustID, SeqNbr
GO
