// Inner class to hold aggregate distance and travel count
    public class AggregateDistanceTravel {
        public Decimal totalDistance { get; set; }
        public Integer customerCount { get; set; }
        public Decimal lastLat { get; set; }
        public Decimal lastLon { get; set; }

        public AggregateDistanceTravel() {
            this.totalDistance = 0;
            this.customerCount = 0;
            this.lastLat = null;
            this.lastLon = null;
        }

        public AggregateDistanceTravel(Decimal totalDistance, Integer customerCount) {
            this.totalDistance = totalDistance;
            this.customerCount = customerCount;
            this.lastLat = null;
            this.lastLon = null;
        }
    }