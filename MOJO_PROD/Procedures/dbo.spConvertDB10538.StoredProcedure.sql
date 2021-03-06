USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10538]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10538]
AS

Update tQuoteReply set Status = 3 where Status = 2




Update tQuote set Status = 3 where QuoteKey in(
Select QuoteKey from (
Select MIN(Status)as minStatus,QuoteKey from tQuoteReply group by QuoteKey) UpdateData
Where UpdateData.minStatus = 3
)



Update tRequest Set Subject = rd.RequestName
from tRequest r
inner join tRequestDef rd on r.RequestDefKey = rd.RequestDefKey
GO
